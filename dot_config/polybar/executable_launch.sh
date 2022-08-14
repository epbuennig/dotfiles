#!/bin/sh

killall -q polybar
pgrep -x polybar > /dev/null && exit 1

polybar top &

if [[ $(xrandr -q | grep 'HDMI-0 connected' ) ]]; then
    polybar top-side &
fi

