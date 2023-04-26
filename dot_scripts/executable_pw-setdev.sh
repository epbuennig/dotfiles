#!/bin/zsh
# swaps between internal/external soundcard
# the metadata only contains the name of the default sink

if [[ "${#}" != '1' ]]; then
    echo "invalid agument count, expected 1, got ${#}: '$@'"
    exit 1
fi

local _headphones_name='alsa_output.pci-0000_03_00.0.analog-stereo'
local _speakers_name='alsa_output.pci-0000_00_1f.3.analog-stereo'

case "${1}" in
    'toggle' | 't')
        local _sink_id=$(~/.scripts/pw-getdev.sh id)

        IFS=$'\n' _sink_ids=($(pw-dump | jq ".[]
            | select(.type == \"PipeWire:Interface:Node\")
            | select(.info.props.\"alsa.card\" != null)
            | select((.info.props.\"factory.name\" | test(\".*sink\")))
            | select((.info.props.\"node.name\" | test(\"${_headphones_name}|${_speakers_name}\")))
            | .id"))

        # there are only 2 on this pc
        if [[ $_sink_id == $_sink_ids[0] ]]; then
            wpctl set-default $_sink_ids[1]
        else
            wpctl set-default $_sink_ids[0]
        fi
    ;;
    'speakers' | 's')
        wpctl set-default $(pw-dump Node Device | jq ".[].info.props 
            | select(.\"node.name\" == \"${_speakers_name}\")
            | .\"object.id\"")
    ;;
    'headphones' | 'h')
        wpctl set-default $(pw-dump Node Device | jq ".[].info.props 
            | select(.\"node.name\" == \"${_headphones_name}\")
            | .\"object.id\"")
    ;;
    *)
        echo "invalid first argument '${1}', expected one of 'toggle|speakers|headphones'"
        exit 1
    ;;
esac

