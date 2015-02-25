#!/usr/bin/perl
use strict;

start('samba');
start('avahi');
start('timemachine');
start('utorrent');
start('btsync');
start('dropbox');
start('plex');
start('camerasync');
start('heyu');

sub start {
    my ($container) = @_;
    return 1 if is_running($container);
    my $tries = 5;
    while ($tries--) {
        warn "Starting $container\n";
        system 'docker', 'start', $container;
        sleep 2;
        return 1 if is_running($container);
    }
    return;
}

sub is_running {
    my ($container) = @_;
    my $running = qx{docker inspect -f '{{.State.Running}}' $container} eq "true\n";
    if ($running) {
        warn "$container is running\n";
        return 1;
    } else {
        return;
    }
}