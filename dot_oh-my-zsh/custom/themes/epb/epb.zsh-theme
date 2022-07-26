local separator="%{$fg[yellow]%}>%{$reset_color%}"

precmd() {
    echo ""
    print -P " \$(~/.scripts/epb-prompt-path)"
    git branch &> /dev/null \
        && print -P " \$(~/.scripts/epb-prompt-git)"
}

PROMPT=" $separator "

