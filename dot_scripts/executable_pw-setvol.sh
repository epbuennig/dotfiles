#!/bin/zsh
# modifies the current default's device volume

if [[ "${#}" != '2' ]]; then
    echo "invalid agument count, expected 2, got ${#}: '$@'"
    exit 1
fi

local _type=''
local _val=''

case "${1}" in
    'set' | 's' | '%')  _val=$2; _type='';;
    'mute' | 'm' | '!') _val=$2; _type='!';;
    'incr' | 'i' | '+') _val=$2; _type='+';;
    'decr' | 'd' | '-') _val=$2; _type='-';;
    *)
        echo "invalid first argument '${1}', expected one of 'set|mute|incr|decr'"
        exti 1
    ;;
esac

if [[ "${_type}" == '!' ]]; then
    case "${_val}" in
        '0' | 'off')    _val='0';;
        '1' | 'on')     _val='1';;
        't' | 'toggle') _val='toggle';;
        *)
            echo "invalid second argument '${2}', expected one of 'on|off|toggle'"
            exit 1
        ;;
    esac
    # set for current device
    wpctl set-mute "$(~/.scripts/pw-getdev.sh id)" "${_val}"
else
    # NOTE: this does not protect from accidentally increasing by 1.0, but it does prevent
    #       increasing by anything higher than that
    if (( "${_val}" < 0.00 )) || (( 1.00 < "${_val}" )); then
        echo "invalid second argument '${2}', must be a number between [0.00, 1.00]"
        exit 1
    fi

    # set for current device
    wpctl set-volume "$(~/.scripts/pw-getdev.sh id)" "${_val}${_type}"
fi
