# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

ZDOTDIR=~/.config/zsh

# Environment variables from home-manager
. "/home/jakub/.nix-profile/etc/profile.d/hm-session-vars.sh"

