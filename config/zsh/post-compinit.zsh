autoload -Uz promptinit
promptinit
autoload colors && colors

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

PS1=$'\n'"%{$fg[blue]%}%~"$'\n'"%{$fg_bold[green]%}λ%{$reset_color%} "

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

<~/.config/art
