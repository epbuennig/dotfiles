# Nushell Environment Config File

let-env PROMPT_COMMAND = { ||
  let pwd = ($env.PWD | str replace $env.HOME "~")

  let path_segment = if (is-admin) {
    $"(ansi red_bold)($pwd)"
  } else {
    $"(ansi green_bold)($pwd)"
  }

  $path_segment
}

let-env PROMPT_COMMAND_RIGHT = { ||
  let time_segment = ([
    (date now | date format '%m/%d/%Y %r')
  ] | str join)

  $time_segment
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { || "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { || ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { || "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { || "::: " }

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
  ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
  ($nu.config-path | path dirname | path join 'plugins')
]

def try-find-bin [] {
  each { |b| which $b } | flatten | where built-in == false | get -i 0.path
}

let bins = [
  ["bins",          "name",      "extras"];

  [["nvim", "vim"], "EDITOR",    []]
  [["hx", "helix"], "EDITOR",    [["HELIX_EDITOR", $"($env.HOME)/.local/share/helix/runtime"]]]
  [["firefox"],     "BRWOSER",   []]
  [["bat"],         "MANPAGER",  []]
  [["delta"],       "GIT_PAGER", []]
]

for var in $bins {
  let value = ($var.bins | try-find-bin)
  let-env $var.name = $value

  for extra in $var.extras {
    let-env $extra.0 = $extra.1
  }
}

if (which gpgconf) != $nothing {
  let-env GPG_TTY = (^tty)
}

let paths = [
  ".local/bin"
  ".cargo/bin"
]

for path in ($paths | where ($it | path exists)) {
  let-env PATH = ($env.PATH | prepend ($env.HOME | path join $path))
}

let-env MEDIA = ($env.HOME | path join "Data/media")

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# NOTE: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n | uniq }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n | uniq }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "LS_COLORS": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
  }
}

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# prepare starship prompt
mkdir ~/.cache/starship
starship init nu | str replace --string "size -c" "size" | save -f ~/.cache/starship/init.nu
