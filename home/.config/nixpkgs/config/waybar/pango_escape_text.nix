{ pkgs ? import <nixpkgs> { } }:

let
  python = (pkgs.python38.buildEnv.override {
    extraLibs = with pkgs.python38Packages; [ pygobject3 ];
  });
in

pkgs.writeScriptBin "pango_escape_text" ''
  #!${python}/bin/python

  import sys
  import gi
  from gi.repository import GLib

  print(GLib.markup_escape_text(' '.join(sys.argv[1:])))''
