use Test::More tests => 2;
use Test::Mojo;
use strict;
use autodie ':all';

use FindBin '$Bin';
use lib $Bin;
use helpers;

start_supervisord;
ok supervisord_running, 'supervisord running';

wait_for 'http://localhost/test' => 404;

localhost_test->get_ok('http://localhost/', 'accepting requests');
