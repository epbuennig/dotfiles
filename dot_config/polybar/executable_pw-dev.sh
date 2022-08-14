#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

local print_device() {
    local _dev=$(~/.scripts/pw-getdev.sh type)

    if [[ "${_dev}" == 's' ]]; then
        echo ""
    else
        echo ""
    fi
}

case "${1}" in
    'status' | 's') print_device;;
    'toggle' | 't') ~/.scripts/pw-setdev.sh toggle && print_device;;
    *)
        echo "invalid first argument '${1}', expected one of 'status|toggle'"
        exit 1
    ;;
esac

