use Test::More;
use Test::Mojo;
use strict;
use autodie ':all';

use FindBin '$Bin';
use lib $Bin;
use helpers;

my $t = localhost_test;

$t->get_ok('http://test1.localhost/status', 'get nonexistant route')
  ->status_is(404);

my $container1 = run_in_container [qw(-h test1.localhost)], 'perl', "$Bin/server.pl", 1;

wait_for 'http://test1.localhost/status' => 200;
$t->get_ok('http://test1.localhost/status')
  ->status_is(200)
  ->content_is('got it 1');

$t->get_ok('http://test2.localhost/status', 'get nonexistant route')
  ->status_is(404);

my $container2 = run_in_container [qw(-h test2.localhost)], 'perl', "$Bin/server.pl", 2;

wait_for 'http://test2.localhost/status' => 200;
$t->get_ok('http://test2.localhost/status')
  ->status_is(200)
  ->content_is('got it 2');

$t->get_ok('http://test1.localhost/status')
  ->status_is(200)
  ->content_is('got it 1');

remove_container $container1;

wait_for 'http://test1.localhost/status' => 404;
$t->get_ok('http://test1.localhost/status')
  ->status_is(404);

$t->get_ok('http://test2.localhost/status')
  ->status_is(200)
  ->content_is('got it 2');

remove_container $container2;

wait_for 'http://test2.localhost/status' => 404;
$t->get_ok('http://test2.localhost/status')
  ->status_is(404);

done_testing;
