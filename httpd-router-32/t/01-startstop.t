use Test::More tests => 4;
use strict;
use autodie ':all';

use FindBin '$Bin';
use lib $Bin;
use helpers;

ok !supervisord_running, 'supervisord not running';
start_supervisord;
ok supervisord_running, 'supervisord running';
sleep 1;
ok supervisord_running, 'supervisord still running after 1 second';
stop_supervisord;
ok !supervisord_running, 'supervisord not running';
