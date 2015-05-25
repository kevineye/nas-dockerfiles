use Test::More tests => 1;
use strict;
use autodie ':all';

use FindBin '$Bin';
use lib $Bin;
use helpers;

stop_supervisord;
ok !supervisord_running, 'stopped';
