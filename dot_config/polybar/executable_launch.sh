#!/bin/bash

# kill all previous
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# always start main
polybar top &

# start side if connected
if [[ $(xrandr -q | grep 'HDMI-0 connected' ) ]]; then
    polybar top-side &
fi

