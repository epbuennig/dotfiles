#!/bin/zsh
# modifies the current default's device volume

if [[ $1 =~ '[+-]0\.[0-9]{1,2}' ]]; then
    local sink_id=$(~/.scripts/pw-getdev.sh id)
    local current=$( \
        pw-cli enum-params "$sink_id" 'Props' \
        | grep -A 2 'Spa:Pod:Object:Param:Props:channelVolumes' \
        | awk '/Float / {gsub(/.*Float\s/," "); print $1^(1/3) }' \
    )

    let "new = current + $1"
    let "new = new > 1.0 ? 1.0 : (new < 0.0 ? 0.0 : new)"
    wpctl set-volume $sink_id $new
elif [[ $1 =~ '(1\.00?)|(0\.[0-9]{1,2})' ]]; then
    local sink_id=$(~/.scripts/pw-getdev.sh id)
    wpctl set-volume $sink_id $1
elif [[ $1 == 'mute' && $2 =~ '0|1|toggle' ]]; then
    local sink_id=$(~/.scripts/pw-getdev.sh id)
    wpctl set-mute $sink_id $2
else
    echo "inlvaid input '$@', expected one of [+|-]0.00...1.00 | mute (0|1|toggle)"
    exit 1
fi

