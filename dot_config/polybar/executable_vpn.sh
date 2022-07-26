#!/bin/zsh

local get_status() {
    local state=$(protonvpn-cli s)

    if [[ $state =~ 'No active Proton VPN connection\.' ]]; then
        echo '%{F#665C54}%{F-}'
    else
        echo '%{F#FABD2F}%{F-}'
    fi
}

if [[ $1 == 'status' ]]; then
    get_status
elif [[ $1 == 'toggle' ]]; then
    local state=$(get_status)

    if [[ $state =~ '' ]]; then
        protonvpn-cli c -f &> /dev/null
        echo '%{F#FABD2F}%{F-}'
    else
        protonvpn-cli d &> /dev/null
        echo '%{F#665C54}%{F-}'
    fi
else
    echo "invalid input '$@', expected one of status | toggle"
    exit 1 
fi

