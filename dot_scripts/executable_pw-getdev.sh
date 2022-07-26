#!/bin/zsh

# get current sink name
local get_sink_name() {
    pw-metadata 0 'default.audio.sink' \
        | grep 'value' \
        | sed "s/.* value:'//;s/' type:.*$//;" \
        | jq '.name'
}

if [[ $1 == 'id' ]]; then
    # query for id
    pw-dump Node Device | jq '.[].info.props 
        | select(."node.name" == '" $(get_sink_name) "')
        | ."object.id"'
elif [[ $1 == 'name' ]]; then 
    local sink_name=$(get_sink_name)

    # remove quotes
    echo ${sink_name:1:(-1)}
else
    echo "invalid input '$@', expected one of name | id"
    exit 1
fi
