#!/bin/sh

killall -q sxhkd
pgrep -x sxhkd > /dev/null || sxhkd &
