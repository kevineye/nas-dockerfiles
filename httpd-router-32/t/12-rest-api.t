use Test::More;
use Test::Mojo;
use strict;
use autodie ':all';

use FindBin '$Bin';
use lib $Bin;
use helpers;

my $container1 = run_in_container [qw(-h test1.localhost)], 'perl', "$Bin/server.pl", 1;
my $container2 = run_in_container [qw(-h test2.localhost)], 'perl', "$Bin/server.pl", 2;

my $t = localhost_test;

$t->put_ok('http://localhost/config/rules' => json => [])->status_is(200)->json_is('' => [], 'put empty rule list');
$t->get_ok('http://localhost/config/rules')->status_is(200)->json_is('' => [], 'got empty rule list');

$t->put_ok('http://localhost/config/rules' => json => [ { from => '^abc\b', container => 'test1' }, { from => '^foo\b', container => 'test2' } ])->status_is(200, 'setup /abc -> test1, /foo -> test2 rule');
wait_for 'http://localhost/abc' => 200;

$t->get_ok('http://localhost/abc')->status_is(200)->content_is('got it 1', '/abc -> test1 working');
$t->get_ok('http://localhost/abcd')->status_is(404, '/abcd !> test1 working');
$t->get_ok('http://localhost/foo')->status_is(200)->content_is('got it 2', '/foo -> test2 working');
$t->get_ok('http://localhost/foo/bar')->status_is(200)->content_is('got it 2', '/foo/bar -> test2 working');

$t->put_ok('http://localhost/config/rules' => json => [])->status_is(200)->json_is('' => [], 'clear rule list');
wait_for 'http://localhost/abc' => 404;
$t->get_ok('http://localhost/abc')->status_is(404, '/abc !> test1 working');

$t->put_ok('http://localhost/config/rules/new' => json => { from => '^abc\b', container => 'test1', group => 'g1' })
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }], 'add rule 1');
$t->put_ok('http://localhost/config/rules/10' => json => { from => '^foo\b', container => 'wrong' })
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^foo\b', container => 'wrong' }], 'add rule 2');
$t->put_ok('http://localhost/config/rules/3' => json => { from => '^baz\b', to => '/bar', external => Mojo::JSON->true })
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^foo\b', container => 'wrong' }, { from => '^baz\b', to => '/bar', external => Mojo::JSON->true }], 'add rule 3');
$t->put_ok('http://localhost/config/rules/new' => json => { from => '^boo\b', to => '/abc', group => 'g1' })
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^foo\b', container => 'wrong' }, { from => '^baz\b', to => '/bar', external => Mojo::JSON->true }, { from => '^boo\b', to => '/abc', group => 'g1' }], 'add rule 4');
$t->put_ok('http://localhost/config/rules/2' => json => { from => '^foo\b', container => 'test2', , group => 'g2' })
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^foo\b', container => 'test2', group => 'g2' }, { from => '^baz\b', to => '/bar', external => Mojo::JSON->true }, { from => '^boo\b', to => '/abc', group => 'g1' }], 'replace rule 1');
wait_for 'http://localhost/abc' => 200;

$t->get_ok('http://localhost/abc')->status_is(200)->content_is('got it 1', '/abc -> test1 working');
$t->get_ok('http://localhost/foo')->status_is(200)->content_is('got it 2', '/foo -> test2 working');
$t->get_ok('http://localhost/baz')->status_is(301)->header_like(Location => qr{/bar$}, '/baz redirect working');
$t->get_ok('http://localhost/abc')->status_is(200)->content_is('got it 1', '/boo-> /abc working');

$t->get_ok('http://localhost/config/groups')
  ->status_is(200)
  ->json_is('' => [ 'g1', 'g2' ], 'got group list');

$t->delete_ok('http://localhost/config/rules/3')
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^foo\b', container => 'test2', group => 'g2' }, { from => '^boo\b', to => '/abc', group => 'g1' }], 'delete rule 3');

$t->get_ok('http://localhost/config/groups/g1')
  ->status_is(200)
  ->json_is('' => [{ from => '^abc\b', container => 'test1', group => 'g1' }, { from => '^boo\b', to => '/abc', group => 'g1' }], 'list g1 rules');
$t->get_ok('http://localhost/config/groups/g2')
  ->status_is(200)
  ->json_is('' => [{ from => '^foo\b', container => 'test2', group => 'g2' }], 'list g2 rules');
$t->delete_ok('http://localhost/config/groups/g1')
  ->status_is(200)
  ->json_is('' => [{ from => '^foo\b', container => 'test2', group => 'g2' }], 'delete g1 rules');
$t->put_ok('http://localhost/config/groups/g2', json => [{ from => 'a' }])
  ->status_is(200)
  ->json_is('' => [{ from => 'a', group => 'g2' }], 'replace g2 rules');

$t->put_ok('http://localhost/config/rules' => json => [])->status_is(200)->json_is('' => [], 'clear rule list');

# TODO test combining container and to
# TODO test rule execution order
# TODO test command line tool
# TODO test yml and template file auto-reload

done_testing;
