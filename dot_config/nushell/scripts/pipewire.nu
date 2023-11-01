#! /usr/bin/env nu
# pipewire controlling functions and environment variables

export-env {
  $env.PIPEWIRE = {
    # matching values given for the path `info.props."node.description"` from pw-dump
    node-matchers: {
      speakers: "Built-in"
      headphones: "Sound Blaster"
    }
  }
}

# use given device or try to query for default device
def device-or-default [] {
  if $in != $nothing { $in } else { device get | where default == true | get id }
}

# TODO: this can probably done using a simpler version using `where ($it | each ... | any)`
#       the issue may be that the $it variable changes for the subshell, since this didn't work
#       when tried

# short hand for multiple matches
# the following:
#   matches-one-of {|e| $e.PATH } [$foo, $bar]
# is equivalent to
#   where PATH =~ $foo or PATH =~ $bar
def matches-one-of [ func, values ] {
  where {|e| $values | each {|v| (do $func $e) =~ $v } | any {|b| $b } }
}

# Return the current pipewire sinks
export def "device get" [] {
  let devices = (^pw-dump Node | from json | where type =~ "Node$")
  let default = (^pw-metadata 0 'default.audio.sink'
    | lines
    | get 1
    # the striping and reading of braces prevents problems with nested values
    | str replace ".*value:'{(.*)}'.*" "{$1}"
    # the format is given as a json object/map
    | from json
    | get name)

  ($devices
    | where info.props."node.description"? != $nothing
    | where info.props."factory.name" == "api.alsa.pcm.sink"
    | matches-one-of {|e| $e.info.props."node.description" } ($env.PIPEWIRE.node-matchers | values)
    | select id info.props."node.description" info.props."node.name"
    | rename id name ident
    | insert default {|e| ($e.ident == $default) }
    | insert type {|e| ([$env.PIPEWIRE.node-matchers]
      | transpose type pattern
      | where {|p| $e.name =~ $p.pattern }
      | get type.0)}
    | select id type default name)
}

# Set the current default device explicitly
export def "device set" [
  id?: int         # set default by id
  --headphones(-H) # set default to headphones
  --speakers(-S)   # set default to speakers
] {
  # unify arguments as given by being false or $nothing
  let args = ([$headphones, $speakers, $id]
    | each {|e| (not ($e in [$nothing, false])) | into int }
    | math sum)

  if ($args | length) != 1 {
    error make { msg: "requires exactly one argument, either none or more than one was given" }
  }

  match [$headphones, $speakers, $id] {
    [true, _, _] => { ^wpctl set-default (device get | where type == headphones | get id) }
    [_, true, _] => { ^wpctl set-default (device get | where type == speakers | get id) }
    _ => { ^wpctl set-default $id }
  }
}

# Toggle default device
export def "device toggle" [] {
  let device = (device get | where default == false | get id)
  device set $device
}

# Return a device's volume in percentage as an integer
export def "volume get" [
  --device(-d): int # the device id, or the default device if $nothing
] {
  let device = ($device | device-or-default)
  ((^wpctl get-volume $device
      | parse -r '.*: (?P<val>\d+\.\d\d)'
      | get val.0
      | into float) * 100
    | into int)
}

# Set the volume for a device
export def "volume set" [
  val: int          # the relative or absolute volume to set
  --device(-d): int # the device id or the default device if $nothing
  --relative(-r)    # whether or not $val is relative
  --clamp           # clamp values instead of throwing an error
] {
  let device = ($device | device-or-default)

  let current = (volume get --device $device)
  let prospected = if $relative {
    $current + $val
  } else {
    $val
  }

  if $prospected not-in 0..100 {
    if $clamp {
      return;
    }

    error make { msg: $"prospected value \(($prospected)\) would lie outside of 0..100" }
  }

  let value = if $relative {
    if $val < 0 {
      $"($val / -100)-"
    } else {
      $"($val / 100)+"
    }
  } else {
    $val / 100
  }

  ^wpctl set-volume $device $value
}

# Mute the current default device
export def "volume mute" [
  val?: bool        # the value to set the mute state to, or toggle if $nothing
  --device(-d): int # the device id or the default device if $nothing
] {
  let device = ($device | device-or-default)
  let val = (if $val == $nothing { "toggle" } else { $val | into int })
  ^wpctl set-mute $device $val
}
