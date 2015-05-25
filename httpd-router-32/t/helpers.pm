use strict;
use autodie ':all';

use POSIX qw(setsid :sys_wait_h);
use Test::Mojo;
use Test::More;

sub supervisord_pid () {
    my ($ps) = qx{ps auxc | grep supervisord | grep -v defunct};
    my ($pid) = $ps =~ m{^\S+\s+(\d+)};
    return $pid;
}

sub supervisord_running () {
    return !!supervisord_pid;
}

sub start_supervisord () {
    die 'already started' if supervisord_running;
    start_daemon( qw(supervisord -c /app/supervisor.conf));
    die 'cannot start' unless supervisord_running;
}

sub stop_supervisord () {
    die 'not started' unless supervisord_running;
    my $retry = 10;
    while ($retry-- and supervisord_running) {
        eval {
            kill 'TERM', supervisord_pid;
        };
        sleep 1;
    }
    eval {
        kill 'KILL', supervisord_pid;
    };
    die 'cannot stop' if supervisord_running;
}

sub get_my_container_id () {
    my $cgroups = qx{cat /proc/self/cgroup};
    $cgroups =~ m{(?::cpu:/docker/|:cpu,cpuacct:/system.slice/docker-)(\w+)};
    return $1;
}

sub get_my_image_id () {
    my $container_id = get_my_container_id;
    my $image_id = qx{docker inspect -f '{{.Image}}' $container_id};
    chomp $image_id;
    return $image_id;
}

my @containers_to_cleanup;
sub run_in_container {
    my @docker_args;
    @docker_args = @{shift()} if ref $_[0];
    my @cmd = ('docker', 'run', '-d', @docker_args, get_my_image_id, @_);
    open my $fh, '-|', @cmd;
    my ($id) = <$fh>;
    eval { close $fh };
    chomp $id;
    push @containers_to_cleanup, $id;
    return $id;
}

sub remove_container ($) {
    my ($id) = @_;
    system "docker rm -f $id";
    @containers_to_cleanup = grep { $_ ne $id } @containers_to_cleanup;
}

END {
    eval {
        system 'docker rm -f ' . join(' ', @containers_to_cleanup) . ' 2>&1 >/dev/null' if @containers_to_cleanup;
    };
}

sub start_daemon {
    my $pid = fork();
    return if $pid;
    open STDIN, "< /dev/null";
    open STDOUT, "> /dev/null";
    setsid();
    open STDERR, ">&STDOUT";
    exec @_;
}

my $t = Test::Mojo->new();
my $transactor = My::Transactor::DNS::Localhost->new;
$t->ua->transactor($transactor);

sub localhost_test () {
    return $t;
}

sub wait_for ($$) {
    my ($url, $status) = @_;
    my $tries = 10;
    select undef, undef, undef, 0.33 while $tries-- and $t->ua->get('http://localhost/')->res->code != $status;
}

package My::Transactor::DNS::Localhost;
use base 'Mojo::UserAgent::Transactor';

# override Mojo::UserAgent::Transactor::peer
sub peer {
    my $self = shift;
    my ($scheme, $host, $port) = $self->SUPER::peer(@_);
    $host = '127.0.0.1';
    return ($scheme, $host, $port);
}

1;
