{ pkgs ? import <nixpkgs> { } }:

let
  pango_escape_text = "${import ./pango_escape_text.nix {}}/bin/pango_escape_text";
in
pkgs.writeScriptBin "mediaplayer" ''
#!${pkgs.stdenv.shell}

PLAYERCTL="${pkgs.playerctl}/bin/playerctl"

if [ -n "$1" ]; then
    PLAYER="$($PLAYERCTL -l | sed -n "$1"p)"
    PLAYERCTL="$PLAYERCTL -p $PLAYER"   
fi

TEXT="$($PLAYERCTL metadata artist) - $($PLAYERCTL metadata title)"

case "$PLAYER" in
    *firefox*)
        TOOLTIP="Firefox"
        TEXT="$($PLAYERCTL metadata title)"
        ;;
    Spotify)
        TOOLTIP="Spotify"
        ;;
    *)
        TOOLTIP="$(${pango_escape_text} "$($PLAYERCTL metadata title)")"
        ;;
esac

TEXT=$(${pango_escape_text} "$TEXT")

echo '{"text": "' "$TEXT"'", "tooltip": "'"$TOOLTIP"'", "class": "'"$($PLAYERCTL status)"'" , "alt": "'"$($PLAYERCTL status)"'"}' | sed -e 's/" - "/""/'
''
