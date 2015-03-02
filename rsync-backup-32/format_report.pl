#!/usr/bin/perl
use strict;

use constant TO => 'kevineye@gmail.com';

use Template::Mustache;

my $out = join '', <>;

my $pattern = <<'PATTERN';
Create a readonly snapshot of '/mnt/sdb1/' in '/mnt/sdb1/backup-freeze'
rsync-backup
GoFlex Home version 10.0.x
GoFlex Home version 10.0.x

Number of files: [0-9,]+ \([^\)]*\)
Number of created files: [0-9,]+ \([^\)]*\)
Number of regular files transferred: [0-9,]+
Total file size: ([0-9,]+) bytes
Total transferred file size: [0-9,]+ bytes
Literal data: [0-9,]+ bytes
Matched data: ([0-9,]+) bytes
File list size: [0-9,]+
File list generation time: [0-9,.]+ seconds
File list transfer time: [0-9,.]+ seconds
Total bytes sent: [0-9,]+
Total bytes received: [0-9,]+

sent ([0-9,]+) bytes\s+received ([0-9,]+) bytes\s+([0-9,.]+) bytes/sec
total size is [0-9,]+\s+speedup is [0-9,.]+
GoFlex Home version 10.0.x
GoFlex Home version 10.0.x
GoFlex Home version 10.0.x

Number of files: [0-9,]+ \([^\)]*\)
Number of created files: [0-9,]+ \([^\)]*\)
Number of regular files transferred: [0-9,]+
Total file size: ([0-9,]+) bytes
Total transferred file size: [0-9,]+ bytes
Literal data: [0-9,]+ bytes
Matched data: ([0-9,]+) bytes
File list size: [0-9,]+
File list generation time: [0-9,.]+ seconds
File list transfer time: [0-9,.]+ seconds
Total bytes sent: [0-9,]+
Total bytes received: [0-9,]+

sent ([0-9,]+) bytes\s+received ([0-9,]+) bytes\s+([0-9,.]+) bytes/sec
total size is [0-9,]+\s+speedup is [0-9,.]+
GoFlex Home version 10.0.x
df: `/var/lib/oe-admin/minions': Permission denied
df: `/var/lib/oe-admin/actions': Permission denied
/dev/sda1\s+[0-9.]+[A-Z]\s*[0-9.]+[A-Z]\s*([0-9.]+[A-Z])\s+([0-9.]+)% /mnt/eSata
Delete subvolume '/mnt/sdb1/backup-freeze'
PATTERN

$pattern =~ s{\n}{\\s+}g;
my @data = $out =~ m{$pattern};

my $data;
if (@data) {
    $data = {
        to => TO,
        volumes => [
            {
                name => 'Everything',
                size => format_size(parse_num($data[0])),
                changed => format_size(parse_num($data[1])),
                time => format_time((parse_num($data[2])+parse_num($data[3]))/parse_num($data[4])),
            },
            {
                name => 'TimeMacine',
                size => format_size(parse_num($data[5])),
                changed => format_size(parse_num($data[6])),
                time => format_time((parse_num($data[7])+parse_num($data[8]))/parse_num($data[9])),
            },
        ],
        available => special_format_size($data[10]),
        available_pct => $data[11],
    };
} else {
    $data = { error => $out, to => TO };
}

my $template = join '', <DATA>;
my $rendered = Template::Mustache->new->render($template, $data);
print $rendered;

sub parse_num {
    my $n = shift;
    $n =~ s{,}{}g;
    return $n + 0;
}

sub format_size {
    my $n = shift;
    if ($n >= 1000000000000) {
        return sprintf '%.1f<small>TB</small>', $n/1000000000000;
    } elsif ($n >= 1000000000) {
        return sprintf '%.0f<small>GB</small>', $n/1000000000;
    } elsif ($n >= 1000000) {
        return sprintf '%.0f<small>MB</small>', $n/1000000;
    } elsif ($n >= 1000) {
        return sprintf '%.0f<small>KB</small>', $n/1000;
    } else {
        return $n;
    }
}

sub format_time {
    my $n = shift;
    if ($n >= 3600) {
        return sprintf '%d<small>h</small>&nbsp;%d<small>m</small>', $n/3600, ($n%3600)/60;
    } else {
        return sprintf '%d<small>m</small>', $n/60;
    }
}

sub special_format_size {
    my $n = shift;
    $n =~ s{([A-Z])$}{<small>\1B</small>};
    return $n;
}


__DATA__
Subject: Backup Report: {{#error}}Errors{{/error}}{{^error}}Success{{/error}}
To: {{to}}
Content-Type: text/html

<style>

div, td, th {
    color: #FFF;
    font: 16px Verdana, sans-serif;
    -webkit-font-smoothing: antialiased;
}

td {
    font-size: 14px;
    border: 0;
    margin: 0;
    padding: 5px 0;
    text-align: right;
}

td img {
    width: 12px;
    height: 12px;
    margin-right: 2px;
    vertical-align: -1px;
    opacity: 0.6;
}

td.volume {
    text-align: left;
}
    
td.volume img {
    width: 24px;
    height: 24px;
    margin-right: 7px;
    vertical-align: -6px;
    opacity: 1;
}

td small {
    font-size: 10px;
    color: rgba(255, 255, 255, 0.6);
    margin-left: 2px;
}

.available small {
    font-size: 10px;
    text-transform: uppercase;
    margin-left: 4px;
}

</style>

<div style="background: #FFF">

{{#error}}
<div style="margin: 0 auto; max-width: 450px; border-top: 4px solid rgb(221, 97, 72); border-bottom: 2px solid rgb(221, 97, 72); background: #f76c51; padding: 60px 10% 60px">
    <pre style="font: 10px 'Andale Mono', Monaco, sans-serif; white-space: pre-wrap">
{{error}}
    </pre>
</div>
{{/error}}

{{^error}}
<div style="margin: 0 auto; max-width: 450px; border-top: 4px solid #337ab7; border-bottom: 2px solid #337ab7; background: #5fa2dd; padding: 50px 10% 70px">

    <table style="margin: 0; padding: 0; border: 0; border-collapse: collapse; width: 100%">
        {{#volumes}}
        <tr>
            <td class="volume"><img src="http://fa2png.io/static/images/hdd-o_ffffff_48.png">{{name}}</td>
            <td class="size">{{{size}}}</td>
            <td class="changed"><img src="http://fa2png.io/static/images/bolt_ffffff_24.png">{{{changed}}}</td>
            <td class="time"><img src="http://fa2png.io/static/images/clock-o_ffffff_24.png">{{{time}}}</td>
        </tr>
        {{/volumes}}
    </table>

    <div style="margin: 40px 0 5px" class="available">
        <img src="http://fa2png.io/static/images/cloud_ffffff_48.png" width="24" height="24" style="vertical-align: -3px; margin-right: 2px"> <span style="font-size: 22px; font-weight: 300">{{{available}}}<small>available</small></span>
    </div>
    <div style="position: relative; height: 2px; background: rgba(255,255,255,0.2)">
        <div style="position: absolute; top: 0; left: 0; bottom: 0; width: {{available_pct}}%; background: #FFF"></div>
    </div>
</div>
{{/error}}

</div>

