#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
fi

if [[ ! "${1}" =~ 'Previous|Next|Play|Pause|PlayPause' ]]; then
    echo "invalid first argument '${1}', expected one of 'Previous|Next|Play|Pause|PlayPause'"
    exit 1
fi

dbus-send --print-reply \
    --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 \
    org.mpris.MediaPlayer2.Player.$1 \
    > /dev/null

