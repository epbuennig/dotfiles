#!/bin/zsh

local print_device() {
    dev=$(~/.scripts/pw-getdev.sh name)

    # speakers: alsa_output.pci-0000_00_1f.3.analog-stereo
    # headphones: alsa_output.pci-0000_03_00.0.analog-stereo
    if [[ $dev == 'alsa_output.pci-0000_00_1f.3.analog-stereo' ]]; then
        echo ""
    else
        echo ""
    fi
}

if [[ $1 == 'status' ]]; then
    print_device
elif [[ $1 == 'toggle' ]]; then
    ~/.scripts/pw-setdev.sh toggle
    print_device
else
    echo "invalid input '$@', expected one of status | toggle"
    exit 1
fi

