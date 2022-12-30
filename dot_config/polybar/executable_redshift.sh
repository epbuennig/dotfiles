#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

# TODO: set command to override current setting manually
local print_temperature() {
    local _temp=$(~/.scripts/redshift.sh temp)
    local _ret=''

    #     ..=4500 black
    # 4501..=5500 red
    # 5501..=6500 white
    # 6501..      blue

    if [[ 6500 < "${_temp}" ]]; then
        _ret='%{F#83A598}' # blue
    elif [[ 5500 < "${_temp}" ]]; then
        _ret='%{F#D5C4A1}' # white/fg
    elif [[ 4500 < "${_temp}" ]]; then
        _ret='%{F#FB4934}' # red
    else
        _ret='%{F#665C54}' # black/bg
    fi

    echo "${_ret}%{F-} %{T1}${_temp}K%{T-}"
}

case "${1}" in
    'status' | 's') print_temperature;;
    *)
        echo "invalid first argument '${1}', expected one of 'status'"
        exit 1
    ;;
esac

