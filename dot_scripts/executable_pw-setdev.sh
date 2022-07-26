#!/bin/zsh
# swaps between internal/external soundcard
# the metadata only contains the name of the default sink

if [[ $1 == 'toggle' ]]; then
    # set from current device
    sink_id=$(~/.scripts/pw-getdev.sh id)

    IFS=$'\n' sink_ids=($( \
        pw-dump | jq '.[]
            | select(.type == "PipeWire:Interface:Node")
            | select(.info.props."alsa.card" != null)
            | select((.info.props."factory.name"| test(".*sink")))
            | .id' \
    ))

    # there are only 2 on this pc
    if [[ $sink_id == $sink_ids[1]  ]]; then
        wpctl set-default $sink_ids[2]
    else
        wpctl set-default $sink_ids[1]
    fi
elif [[ $1 == 'speakers' ]]; then
    # speakers
    # alsa_output.pci-0000_00_1f.3.analog-stereo
    wpctl set-default $( \
        pw-dump Node Device | jq '.[].info.props 
            | select(."node.name" == "alsa_output.pci-0000_00_1f.3.analog-stereo")
            | ."object.id"' \
    )
elif [[ $1 == 'headphones' ]]; then
    # headphones
    # alsa_output.pci-0000_03_00.0.analog-stereo
    wpctl set-default $( \
        pw-dump Node Device | jq '.[].info.props 
            | select(."node.name" == "alsa_output.pci-0000_03_00.0.analog-stereo")
            | ."object.id"' \
    )
else
    echo "invalid input '$@', expected one of toggle | speakers | headphones"
    exit 1
fi

