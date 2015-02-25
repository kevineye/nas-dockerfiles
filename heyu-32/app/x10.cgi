#!/bin/bash
if [[ $QUERY_STRING =~ 'callback=([^&]+)' ]]; then
    echo 'Content-type: application/javascript'
    echo
    echo -n "${BASH_REMATCH[1]}("
else
    echo 'Content-type: application/json'
    echo
fi

device=$(echo $PATH_INFO | cut -d/ -f2)
command=$(echo $PATH_INFO | cut -d/ -f3)

err=$(/usr/local/bin/heyu $command $device 2>&1) && echo -n '{ "device":"'$device'", "command":"'$command'", "success":true }' || echo -n '{ "device":"'$device'", "command":"'$command'", "success":false, "error":"'$err'" }'

if [[ $QUERY_STRING =~ 'callback=([^&]+)' ]]; then
    echo -n ');'
fi

echo