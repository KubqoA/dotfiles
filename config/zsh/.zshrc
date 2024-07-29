# my minimal zshrc config, with few plugins downloaded by git and manually sourced
# performance improvements and tweaks inspired by
# - https://github.com/htr3n/zsh-config
# - https://medium.com/@voyeg3r/holy-grail-of-zsh-performance-a56b3d72265d

# eliminates duplicates in *paths
typeset -U path cdpath fpath manpath


# Auto-generate by nix
HELPDIR="/nix/store/6j0z9mfl6qwz1ra3zdi8b5syjnf5pw2l-zsh-5.9/share/zsh/$ZSH_VERSION/help"


# Add autocompletions from Nix
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done


# Autoload compinit with caching for 24h
setopt extendedglob
autoload -Uz compinit
if [[ ! -f $ZDOTDIR/.zcompdump || -n $ZDOTDIR/.zcompdump(#qNmh+24) ]]; then
	compinit
  touch $ZDOTDIR/.zcompdump
  zcompile $ZDOTDIR/.zcompdump
else
	compinit -C;
fi


# Autloaded functions
fpath+=($ZDOTDIR/autoloaded)
# - z (zoxide) runs an eval so defer that until z is used to speed up load time
autoload z

# direnv integration
eval "$(direnv hook zsh)"

if [ "$SSH_AUTH_SOCK" = "/run/user/1000/keyring/ssh" ]; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# History options
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$XDG_DATA_HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

# Aliases
source $ZDOTDIR/.aliases

# Fix home, end and delete
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char


# Plugins
# Set pure as prompt
fpath+=($ZDOTDIR/plugins/pure)
autoload -U promptinit; promptinit
prompt pure

# Enable https://github.com/zsh-users/zsh-autosuggestions
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable https://github.com/zsh-users/zsh-history-substring-search
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Enable https://github.com/zsh-users/zsh-syntax-highlighting
# Configuration of highlighting - https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters/main
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Is this necessary?
# GPG_TTY="$(tty)"
# export GPG_TTY
# /nix/store/wd3xl6h29kjr9ng2kl0yf3mh7ciw3pri-gnupg-2.4.1/bin/gpg-connect-agent updatestartuptty /bye > /dev/null

cat <$ZDOTDIR/art

