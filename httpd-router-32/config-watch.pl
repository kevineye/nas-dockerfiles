#!/usr/bin/perl
use strict;
use autodie qw(:all);

use Mojo::IOLoop;
use Mojo::JSON qw(decode_json);
use Mojo::Template;

# check usage
die "$0: output.conf template.mt [ template.mt ... ]" if @ARGV < 2;
my ($htaccess, @templates) = @ARGV;

# start watching docker events
open my $docker_events_fh, '-|', 'docker events';

# figure out our ID so we can ignore ourself
my $my_container_id = get_my_container_id();

# write initial empty config
update();

# process each already-running container as if it just started
chomp and handle_container_start($_) for qx{docker ps -q};

# start watching files and docker event socket for changes
# this starts a Mojo::IOLoop and will not return
watch(\@templates => \&config_change, [ $docker_events_fh ] => \&handle_docker_event);


# --------


my %containers; # keeps track of running containers


# process a config change (basically just trigger a config update)
sub config_change () {
    warn "[conf ] template updated\n";
    update();
}


# re-generate the apache .htaccess file
sub update () {
    # open temp new .htaccess file
    open my $conf, '>', "$htaccess~";

    # for each template file (and only ones that look like template files)
    for my $template (grep { /\.mt$/ } @templates) {
        # render each file as a Mojo template, passing in running containers as args
        print $conf "### FROM $template\n\n";
        print $conf Mojo::Template->new()->render_file($template, values %containers);
        print $conf "\n\n\n";
    }

    # close config and rename temp config to real one
    # do it like this to prevent apache from using half-written config file
    close $conf;
    rename "$htaccess~", $htaccess;
}


# handle a single line from 'docker events' output
sub handle_docker_event ($) {
    my ($line) = @_;

    # parse line
    my ($timestamp, $id, $image, $event) = $line =~ m{(\S+) (\S+): \(from (\S+)\) (\S+)};

    # dispatch
    if ($event eq 'start') {
        handle_container_start($id);
    } elsif ($event eq 'die') {
        handle_container_stop($id);
    }
}


# process container start event (get info, add to list, trigger update)
sub handle_container_start ($) {
    my ($id) = @_; # may be short or long ID

    warn "[start] $id\n";

    # get all info about this container
    my $info = get_container_info($id);
    return unless ref $info;

    # ignore ourself
    return if $info->{Id} eq $my_container_id;
    
    # add parsed ENV data
    parse_container_env($info);

    # store; make sure to use long id from info, not supplied arg
    $containers{$info->{Id}} = $info;

    # trigger config update
    update();
}


# process container stop event (remove from list, trigger update)
sub handle_container_stop ($) {
    my ($id) = @_; # must be long ID

    warn "[stop ] $id\n";

    # remove from our list
    delete $containers{$id} if exists $containers{$id};

    # trigger config update
    update();
}


# run 'docker inspect' to get container info
sub get_container_info ($) {
    my ($id) = @_; # may be short or long ID, or even container name

    # run 'docker inspect' and parse output
    my $info = decode_json scalar qx{docker inspect $id};

    # return info if it looks right
    return $info && ref $info && $info->[0];
}


# figure out my container ID by parsing /proc/self/cgroup
sub get_my_container_id () {
    my $cgroups = qx{cat /proc/self/cgroup};
    $cgroups =~ m{:cpu:/docker/(\S+)};
    return $1;
}


# parse ENV args and add to container info
sub parse_container_env($) {
    my ($info) = @_;
    my %env;
    m{^(\w+)=(.*)} and $env{$1} = $2 for @{$info->{Config}{Env} || []};
    $info->{Env} = \%env;
}


my $file_watch_cache = {}; # track state of watched files


# check if a given file has changed
# adapted from Mojo::Server::Morbo::_check
sub file_changed ($) {
    my ($file) = @_;
    my ($size, $mtime) = (stat $file)[7, 9];
    return unless defined $mtime;
    my $stats = $file_watch_cache->{$file} ||= [$^T, $size];
    return if $mtime <= $stats->[0] && $size == $stats->[1];
    return !!($file_watch_cache->{$file} = [$mtime, $size]);
}


# check if any of given files have changed
sub any_changed ($) {
    my ($files) = @_;
    file_changed $_ and return 1 for @$files;
    return;
}


# run IO loop that watches given files for changes and file descriptors for events
sub watch ($&$&) {
    my ($watch, $watch_cb, $read, $read_cb) = @_;

    # filter list of files to watch to files that exist and are readable
    $watch = [ grep { $_ && -r $_ } @$watch ];

    if (@$watch) {
        my $timer;

        # check files, then set a time to check again in one second
        $timer = sub {
            $watch_cb->() if any_changed($watch);
            Mojo::IOLoop->timer(1 => $timer);
        };

        # start the file check timer
        $timer->();
    }

    # setup io watcher for each filehandle
    for my $fh (@$read) {
        Mojo::IOLoop->singleton->reactor->io($fh => sub {
            exit if eof($fh);
            $read_cb->(scalar <$fh>);
        })->watch($fh, 1, 0);
    }

    # start event loop
    Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}
