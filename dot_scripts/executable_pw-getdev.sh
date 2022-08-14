#!/bin/zsh

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

local _headphones_name='alsa_output.pci-0000_03_00.0.analog-stereo'
local _speakers_name='alsa_output.pci-0000_00_1f.3.analog-stereo'

# get current sink name
local _get_sink_name() {
    local _sink_name=$(pw-metadata 0 'default.audio.sink' \
        | grep 'value' \
        | sed "s/.* value:'//;s/' type:.*$//;" \
        | jq '.name')

    # remove quotes
    echo ${_sink_name:1:(-1)}
}

case "${1}" in
    'type' | 't')
        if [[ "$(_get_sink_name)" == "${_headphones_name}" ]]; then
            echo "h"
        else
            echo "s"
        fi
    ;;
    'name' | 'n') _get_sink_name;;
    'id' | 'i')
        # NOTE: when interpolate _args directly as jq args it sometimes fails randomly?
        #       can this be a zsh regression because it can't be jq, because jq is not called before
        #       interpolation is finished, found when trying to debug with echo lol
        local _args=".[].info.props
            | select(.\"node.name\" == \"$(_get_sink_name)\")
            | .\"object.id\""

        pw-dump Node Device | jq $_args
    ;;
    *)
        echo "invalid first argument '${1}', expected one of 'name|id'"
        exit 1
    ;;
esac
