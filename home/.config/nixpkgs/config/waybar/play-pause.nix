{ pkgs ? import <nixpkgs> { } }:

pkgs.writeScriptBin "play-pause" ''
#!${pkgs.stdenv.shell}

PLAYERCTL="${pkgs.playerctl}/bin/playerctl"

if [ -n "$1" ]; then
  PLAYER="$(playerctl -l | sed -n "$1"p)"
  PLAYERCTL="$PLAYERCTL -p $PLAYER"   
fi

$PLAYERCTL play-pause
''
