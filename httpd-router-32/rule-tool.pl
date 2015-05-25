#!/usr/bin/perl
use strict;
use autodie ':all';
use FindBin '$Bin';

use Mojo::JSON qw(decode_json encode_json);
use YAML;

use constant RULES_FILE => "$Bin/rules.yml";

my ($cmd, $param, $action, $data);

if ($ENV{PATH_INFO}) {
    # /api/groups GET
    # /api/groups/<group> GET DELETE PUT
    # /api/rules/<num> GET DELETE PUT
    # /api/rules GET PUT
    my @path = split '/', $ENV{PATH_INFO};
    $cmd = $path[1];
    $param = $path[2];
    $action = lc $ENV{REQUEST_METHOD};
    $action = 'put' if $action eq 'post';
    $data = decode_json join '', <> if $action eq 'put';
} else {
    $cmd = shift;
    $action = shift;
    $param = shift unless -f $ARGV[0];
    $data = decode_json join '', <> if $action eq 'put';
    die "usage: $0 rules {get|put}\n       $0 rules <num> {get|put|delete}\n       $0 groups get\n       $0 groups <group> {get|put|delete}\n" unless $cmd && $action && ($action ne 'put' || ref $data);
}

my $rules = YAML::LoadFile(RULES_FILE);
my $sub = "${cmd}_${action}_" . ($param ? 'one' : 'all');
my $result = main->can($sub)->($rules, $data, $param);

print "Content-type: application/json; charset=UTF-8\n\n" if $ENV{PATH_INFO};
print encode_json $result;
print "\n";


sub rules_get_all {
    my ($rules) = @_;
    $rules->{rules} ||= [];
    return $rules->{rules};
}

sub rules_put_all {
    my ($rules, $new) = @_;
    $rules->{rules} = $new;
    save($rules);
    return $rules->{rules};
}

sub save {
    my ($new) = @_;
    $YAML::UseHeader = 0;
    #YAML::DumpFile(RULES_FILE . '~', $new);
    #rename RULES_FILE . '~', RULES_FILE;
    YAML::DumpFile(RULES_FILE, $new);
}

sub rules_get_one {
    my ($rules, undef, $n) = @_;
    $rules->{rules} ||= [];
    return $rules->{rules}[$n];
}

sub rules_put_one {
    my ($rules, $new, $n) = @_;
    # TODO add insert option
    $n = @{$rules->{rules}} + 1 if $n eq 'new' or $n > @{$rules->{rules}};
    $rules->{rules}[$n-1] = $new;
    save($rules);
    return $rules->{rules};
}

sub rules_delete_one {
    my ($rules, undef, $n) = @_;
    $rules->{rules} ||= [];
    splice @{$rules->{rules}}, $n-1, 1;
    save($rules);
    return $rules->{rules};
}

sub groups_get_all {
    my ($rules) = @_;
    my %groups;
    exists $_->{group} and $_->{group} and $groups{$_->{group}} = 1 for @{$rules->{rules} || []};
    return [ sort keys %groups ];
}

sub groups_get_one {
    my ($rules, undef, $group) = @_;
    return [ grep { exists $_->{group} && $_->{group} eq $group } @{$rules->{rules} ||= []} ];
}

sub groups_put_one {
    my ($rules, $new, $group) = @_;
    # TODO add insert option
    # TODO preserve existing ordering
    my @r = grep { !exists $_->{group} || $_->{group} ne $group } @{$rules->{rules} ||= []};
    for my $n (@$new) {
        $n->{group} = $group;
        push @r, $n;
    }
    $rules->{rules} = \@r;
    save($rules);
    return $rules->{rules};
}

sub groups_delete_one {
    my ($rules, undef, $group) = @_;
    $rules->{rules} = [ grep { !exists $_->{group} || $_->{group} ne $group } @{$rules->{rules} ||= []} ];
    save($rules);
    return $rules->{rules};
}

