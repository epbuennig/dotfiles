#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

local get_status() {
    local _state=$(protonvpn-cli s)

    # TODO: when vpn install is fixed, search for connected instead of checking for all possibl
    #       error cases
    if [[ "${_state}" =~ 'No active Proton VPN connection\.|Traceback.*' ]]; then
        echo '0'
    else
        echo '1'
    fi
}

case "${1}" in
    'status' | 's') get_status;;
    'toggle' | 't')
        local _state=$(get_status)

        if [[ "${_state}" =~ '0' ]]; then
            protonvpn-cli c -f &> /dev/null
            echo '1'
        else
            protonvpn-cli d &> /dev/null
            echo '0'
        fi
    ;;

    *)
        echo "invalid first argument '${1}', expected one of 'status|toggle'"
        exit 1
    ;;
esac
