#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

# TODO: set command to override current setting manually
local print_temperature() {
    local _temp=$(redshift -p 2> /dev/null | grep temperature | awk '{ print $3 }')
    echo "${_temp:0:(-1)}"
}

case "${1}" in
    'temp' | 't') print_temperature;;
    *)
        echo "invalid first argument '${1}', expected one of 'temp'"
        exit 1
    ;;
esac

