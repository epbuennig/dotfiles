# Nushell Environment Config File

$env.PROMPT_COMMAND = { ||
  let pwd = ($env.PWD | str replace $env.HOME "~")

  let path_segment = if (is-admin) {
    $"(ansi red_bold)($pwd)"
  } else {
    $"(ansi green_bold)($pwd)"
  }

  $path_segment
}

$env.PROMPT_COMMAND_RIGHT = { ||
  let time_segment = ([
    (date now | format date '%m/%d/%Y %r')
  ] | str join)

  $time_segment
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { || "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { || ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { || "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { || "::: " }

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
  ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
  ($nu.config-path | path dirname | path join 'plugins')
]

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# NOTE: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
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

def in-home [ path ] {
  $env.HOME | path join $path
}

let paths = [
  (in-home ".rye/shims")
  (in-home ".cargo/bin")
  (in-home ".local/bin")
]

for path in ($paths | where ($it | path exists) | reverse) {
  $env.PATH = ($env.PATH | prepend $path)
}

let bins = [
  ["bins",               "name",        "extras"];

  [["zsh", "bash"],      "SXHKD_SHELL", []]
  [["xdg-open", "open"], "OPENER",      []]
  [["nvim", "vim"],      "EDITOR",      []]
  [["hx", "helix"],      "EDITOR",      [["HELIX_RUNTIME", $"($env.HOME)/.local/share/helix/runtime"]]]
  [["firefox"],          "BROWSER",     []]
  [["delta"],            "GIT_PAGER",   []]
]

def try-find-bin [] {
  each { |b| which $b } | flatten | where path != '' | get -i 0.path
}

for var in $bins {
  let value = ($var.bins | try-find-bin)
  load-env { $var.name: $value }

  for extra in $var.extras {
    load-env { $extra.0: $extra.1 }
  }
}

if (which gpgconf) != null {
  $env.GPG_TTY = ^tty
}

$env.MEDIA = ($env.HOME | path join "Data/media")
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config/starship/config.toml")
$env.RIPGREP_CONFIG_PATH = ($env.HOME | path join ".config/ripgrep/config")

# prepare starship prompt
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# prepare starship prompt
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu
