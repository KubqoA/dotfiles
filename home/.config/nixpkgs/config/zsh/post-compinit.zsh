autoload -Uz promptinit
promptinit
autoload colors && colors
PS1=$'\n'"%{$fg[blue]%}%~"$'\n'"%{$fg[green]%}%{$reset_color%} "

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

<~/.config/art
