# Nushell Config File

def exists [ $name: string ] {
  (which $name).type?.0 == external
}

module aliases {
  export alias gd = ^git diff
  export alias gs = ^git status
  export alias gl = ^git log --all --graph

  export alias gf = ^git fetch
  export alias gp = ^git push

  export alias gr = ^git rebase
  export alias gm = ^git merge

  export alias ga = ^git add
  export alias gcm = ^git commit -m
  export alias gam = ^git commit -v --amend --no-edit
  export alias gst = ^git stash push --staged

  export alias gn = ^systemctl poweroff
  export alias brb = ^systemctl reboot
  export alias vpn = ^protonvpn-cli
  export alias sed = ^sed -r
  export alias dots = ^chezmoi
  export alias ip = ^ip -c -p
  export alias exa = ^exa --icons --git
  export alias dpss = ^docker ps "table {{.ID}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Names}}"

  export alias tt = ^typst-test
}

use aliases *

# for more information on themes see
# https://www.nushell.sh/book/coloring_and_theming.html
let dark_theme = {
  # color for nushell primitives
  separator: white
  leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
  header: green_bold
  empty: blue
  bool: white
  int: white
  filesize: white
  duration: white
  date: white
  range: white
  float: white
  string: white
  nothing: white
  binary: white
  cellpath: white
  row_index: green_bold
  record: white
  list: white
  block: white
  hints: dark_gray

  # shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b }
  shape_binary: purple_bold
  shape_bool: light_cyan
  shape_int: purple_bold
  shape_float: purple_bold
  shape_range: yellow_bold
  shape_internalcall: cyan_bold
  shape_external: cyan
  shape_externalarg: green_bold
  shape_literal: blue
  shape_operator: yellow
  shape_signature: green_bold
  shape_string: green
  shape_string_interpolation: cyan_bold
  shape_datetime: cyan_bold
  shape_list: cyan_bold
  shape_table: blue_bold
  shape_record: cyan_bold
  shape_block: blue_bold
  shape_filepath: cyan
  shape_directory: cyan
  shape_globpattern: cyan_bold
  shape_variable: purple
  shape_flag: blue_bold
  shape_custom: green
  shape_nothing: light_cyan
  shape_matching_brackets: { attr: u }
}

let light_theme = {
  # color for nushell primitives
  separator: dark_gray
  leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
  header: green_bold
  empty: blue
  bool: dark_gray
  int: dark_gray
  filesize: dark_gray
  duration: dark_gray
  date: dark_gray
  range: dark_gray
  float: dark_gray
  string: dark_gray
  nothing: dark_gray
  binary: dark_gray
  cellpath: dark_gray
  row_index: green_bold
  record: white
  list: white
  block: white
  hints: dark_gray

  # shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
  shape_binary: purple_bold
  shape_bool: light_cyan
  shape_int: purple_bold
  shape_float: purple_bold
  shape_range: yellow_bold
  shape_internalcall: cyan_bold
  shape_external: cyan
  shape_externalarg: green_bold
  shape_literal: blue
  shape_operator: yellow
  shape_signature: green_bold
  shape_string: green
  shape_string_interpolation: cyan_bold
  shape_datetime: cyan_bold
  shape_list: cyan_bold
  shape_table: blue_bold
  shape_record: cyan_bold
  shape_block: blue_bold
  shape_filepath: cyan
  shape_directory: cyan
  shape_globpattern: cyan_bold
  shape_variable: purple
  shape_flag: blue_bold
  shape_custom: green
  shape_nothing: light_cyan
  shape_matching_brackets: { attr: u }
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
  # theme
  color_config: $dark_theme
  # TODO: what does this do
  use_grid_icons: true
  # always, never, number_of_rows, auto
  footer_mode: "25"
  # default float precision
  float_precision: 2
  # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  # buffer_editor: "emacs"
  use_ansi_coloring: true
  # emacs, vi
  edit_mode: emacs
  # BUG: this currently causes the prompt to behave weirdly on resizes, but turning it off makes kitty prompt when closing the window
  shell_integration: true
  # true or false to enable or disable the banner
  show_banner: false
  # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  render_right_prompt_on_last_line: false
  # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
  use_kitty_protocol: false
  # enable bracketed pasting for reedline
  bracketed_paste: true
  # true enables highlighting of external commands in the repl resolved by which.
  highlight_resolved_externals: true
  filesize: {
    # true => (KB, MB, GB), false => (KiB, MiB, GiB)
    metric: false
    # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
    format: "auto"
  }
  ls: {
    # use $LS_COLORS
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    # move to trash instead of deleting permanently
    always_trash: true
  }
  # cd: {
  #   # allow expansion of shortened paths
  #   abbreviations: true
  # }
  table: {
    # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none,
    # other
    mode: light
    # always, never, auto
    index_mode: always
    # a left right padding of each column in a table
    padding: { left: 1, right: 1 }
    # a strategy of managing table view in case of limited space.
    trim: {
      # wrapping, truncating
      methodology: wrapping
      # a strategy which will be used by 'wrapping' methodology
      wrapping_try_keep_words: true
      # a suffix which will be used with 'truncating' methodology
      truncating_suffix: "..."
    }
  }
  explore: {
    status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" },
    command_bar_text: { fg: "#C4C9C6" },
    highlight: { fg: "black", bg: "yellow" },
    status: {
      error: { fg: "white", bg: "red" },
      warn: {}
      info: {}
    },
    tble: {
      split_line: { fg: "#404040" },
      selected_cell: { bg: light_blue },
      selected_row: {},
      selected_column: {},
    }
  }
  history: {
    max_size: 10000
    # allows sharing between sessions
    sync_on_enter: true
    # sqlite, plaintext
    file_format: "plaintext"
  }
  completions: {
    case_sensitive: false
    # set this to false to prevent auto-selecting completions when only one remains
    quick: true 
    # set this to false to prevent partial filling of the prompt
    partial: true 
    # prefix, fuzzy
    algorithm: "fuzzy"
    # see above
    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true
      # setting it lower can improve completion performance at the cost of omitting some options
      max_results: 100
      completer: (if (exists carapace) {
        {|spans| ^carapace $spans.0 nushell $spans | from json }
      } else {
        null
      })
    }
  }
  hooks: {
    pre_prompt: [{||
      null # replace with source code to run before the prompt is shown
    }]
    pre_execution: [{||
      null # replace with source code to run before the repl input is run
    }]
    env_change: {}
    # when invoked with non table outputs this causes less to be called with no argc == 0,
    # missing the required argv[0] == "less"
    # display_output: { table | less -FRSX }
  }
  menus: [
    # Configuration for default nushell menus
    # Note the lack of souce parameter
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: columnar
        columns: 4
        # Optional value. If missing all the screen width is used to calculate column width
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: description
        columns: 4
        # Optional value. If missing all the screen width is used to calculate column width
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: commands_menu
      only_buffer_difference: false
      marker: "# "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| {value: $it.name description: $it.usage} }
      }
    }
    {
      name: vars_menu
      only_buffer_difference: true
      marker: "# "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.vars
        | where name =~ $buffer
        | sort-by name
        | each { |it| {value: $it.name description: $it.type} }
      }
    }
    {
      name: commands_with_description
      only_buffer_difference: true
      marker: "# "
      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| { value: $it.name description: $it.usage } }
      }
    }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu, name: completion_menu }
          { send: menunext }
          { edit: complete }
        ]
      }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: [emacs, vi_insert, vi_normal]
      event: { send: menu, name: history_menu }
    }
    {
      name: help_menu
      modifier: none
      keycode: f1
      mode: [emacs, vi_insert, vi_normal]
      event: { send: menu, name: help_menu }
    }
    {
      name: completion_previous_menu
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: next_page_menu
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page_menu
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
      }
    }
    {
      name: escape
      modifier: none
      keycode: escape
      mode: [emacs, vi_normal, vi_insert]
      event: { send: esc }    # NOTE: does not appear to work
    }
    {
      name: cancel_command
      modifier: control
      keycode: char_c
      mode: [emacs, vi_normal, vi_insert]
      event: { send: ctrlc }
    }
    {
      name: quit_shell
      modifier: control
      keycode: char_d
      mode: [emacs, vi_normal, vi_insert]
      event: { send: ctrld }
    }
    {
      name: clear_screen
      modifier: control
      keycode: char_l
      mode: [emacs, vi_normal, vi_insert]
      event: { send: clearscreen }
    }
    {
      name: search_history
      modifier: control
      keycode: char_q
      mode: [emacs, vi_normal, vi_insert]
      event: { send: searchhistory }
    }
    {
      name: open_command_editor
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: openeditor }
    }
    {
      name: move_up
      modifier: none
      keycode: up
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: menuup }
          { send: up }
        ]
      }
    }
    {
      name: move_down
      modifier: none
      keycode: down
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: menudown }
          { send: down }
        ]
      }
    }
    {
      name: move_left
      modifier: none
      keycode: left
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: menuleft }
          { send: left }
        ]
      }
    }
    {
      name: move_right_or_take_history_hint
      modifier: none
      keycode: right
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintcomplete }
          { send: menuright }
          { send: right }
        ]
      }
    }
    {
      name: move_one_word_left
      modifier: control
      keycode: left
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: movewordleft }
    }
    {
      name: move_one_word_right_or_take_history_hint
      modifier: control
      keycode: right
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintwordcomplete }
          { edit: movewordright }
        ]
      }
    }
    {
      name: move_to_line_start
      modifier: none
      keycode: home
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_start
      modifier: control
      keycode: char_a
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_end_or_take_history_hint
      modifier: none
      keycode: end
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintcomplete }
          { edit: movetolineend }
        ]
      }
    }
    {
      name: move_to_line_end_or_take_history_hint
      modifier: control
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintcomplete }
          { edit: movetolineend }
        ]
      }
    }
    {
      name: move_to_line_start
      modifier: control
      keycode: home
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_end
      modifier: control
      keycode: end
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: movetolineend }
    }
    {
      name: move_up
      modifier: control
      keycode: char_p
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: menuup }
          { send: up }
        ]
      }
    }
    {
      name: move_down
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { send: menudown }
          { send: down }
        ]
      }
    }
    {
      name: delete_one_character_backward
      modifier: none
      keycode: backspace
      mode: [emacs, vi_insert]
      event: { edit: backspace }
    }
    {
      name: delete_one_word_backward
      modifier: control
      keycode: backspace
      mode: [emacs, vi_insert]
      event: { edit: backspaceword }
    }
    {
      name: delete_one_character_forward
      modifier: none
      keycode: delete
      mode: [emacs, vi_insert]
      event: { edit: delete }
    }
    {
      name: delete_one_character_forward
      modifier: control
      keycode: delete
      mode: [emacs, vi_insert]
      event: { edit: delete }
    }
    {
      name: delete_one_character_forward
      modifier: control
      keycode: char_h
      mode: [emacs, vi_insert]
      event: { edit: backspace }
    }
    {
      name: delete_one_word_backward
      modifier: control
      keycode: char_w
      mode: [emacs, vi_insert]
      event: { edit: backspaceword }
    }
    {
      name: move_left
      modifier: none
      keycode: backspace
      mode: vi_normal
      event: { edit: moveleft }
    }
    {
      name: newline_or_run_command
      modifier: none
      keycode: enter
      mode: emacs
      event: { send: enter }
    }
    {
      name: move_left
      modifier: control
      keycode: char_b
      mode: emacs
      event: {
        until: [
          { send: menuleft }
          { send: left }
        ]
      }
    }
    {
      name: move_right_or_take_history_hint
      modifier: control
      keycode: char_f
      mode: emacs
      event: {
        until: [
          { send: historyhintcomplete }
          { send: menuright }
          { send: right }
        ]
      }
    }
    {
      name: redo_change
      modifier: control
      keycode: char_g
      mode: emacs
      event: { edit: redo }
    }
    {
      name: undo_change
      modifier: control
      keycode: char_z
      mode: emacs
      event: { edit: undo }
    }
    {
      name: paste_before
      modifier: control
      keycode: char_y
      mode: emacs
      event: { edit: pastecutbufferbefore }
    }
    {
      name: cut_word_left
      modifier: control
      keycode: char_w
      mode: emacs
      event: { edit: cutwordleft }
    }
    {
      name: cut_line_to_end
      modifier: control
      keycode: char_k
      mode: emacs
      event: { edit: cuttoend }
    }
    {
      name: cut_line_from_start
      modifier: control
      keycode: char_u
      mode: emacs
      event: { edit: cutfromstart }
    }
    {
      name: swap_graphemes
      modifier: control
      keycode: char_t
      mode: emacs
      event: { edit: swapgraphemes }
    }
    {
      name: move_one_word_left
      modifier: alt
      keycode: left
      mode: emacs
      event: { edit: movewordleft }
    }
    {
      name: move_one_word_right_or_take_history_hint
      modifier: alt
      keycode: right
      mode: emacs
      event: {
        until: [
          { send: historyhintwordcomplete }
          { edit: movewordright }
        ]
      }
    }
    {
      name: move_one_word_left
      modifier: alt
      keycode: char_b
      mode: emacs
      event: { edit: movewordleft }
    }
    {
      name: move_one_word_right_or_take_history_hint
      modifier: alt
      keycode: char_f
      mode: emacs
      event: {
        until: [
          { send: historyhintwordcomplete }
          { edit: movewordright }
        ]
      }
    }
    {
      name: delete_one_word_forward
      modifier: alt
      keycode: delete
      mode: emacs
      event: { edit: deleteword }
    }
    {
      name: delete_one_word_backward
      modifier: alt
      keycode: backspace
      mode: emacs
      event: { edit: backspaceword }
    }
    {
      name: delete_one_word_backward
      modifier: alt
      keycode: char_m
      mode: emacs
      event: { edit: backspaceword }
    }
    {
      name: cut_word_to_right
      modifier: alt
      keycode: char_d
      mode: emacs
      event: { edit: cutwordright }
    }
    {
      name: upper_case_word
      modifier: alt
      keycode: char_u
      mode: emacs
      event: { edit: uppercaseword }
    }
    {
      name: lower_case_word
      modifier: alt
      keycode: char_l
      mode: emacs
      event: { edit: lowercaseword }
    }
    {
      name: capitalize_char
      modifier: alt
      keycode: char_c
      mode: emacs
      event: { edit: capitalizechar }
    }
  ]
}

# configure gpg
if (exists gpgconf) {
  ^gpgconf --launch gpg-agent
}

# NOTE: the startup time is significantly slowed down by this, maybe this should just be a service
# if (exists autocutsel) {
#   let vars = (ps | where name == autocutsel)
#   match ($vars | is-empty) {
#     0 => { autocutsel -selection CLIPBOARD -fork }
#     1 => {}
#     _ => { $vars | skip 1 | each { |it| kill $it } }
#   }
# }

# load starship prompt
source ~/.cache/starship/init.nu
