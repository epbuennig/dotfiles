#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

local get_status() {
    local _state=$(~/.scripts/vpn.sh status)

    if [[ "${_state}" =~ '0' ]]; then
        echo '%{F#665C54}%{F-}'
    else
        echo '%{F#FABD2F}%{F-}'
    fi
}

case "${1}" in
    'status' | 's') get_status;;
    'toggle' | 't') ~/.scripts/vpn.sh toggle &> /dev/null && get_status;;
    *)
        echo "invalid first argument '${1}', expected one of 'status|toggle'"
        exit 1
    ;;
esac
