{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "WhiteSur-icon-theme";
  pname = "WhiteSur-icon-theme";
  version = "2020-10-11";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1az7aa3p0knc9kjhk9bqpl9x230b4ygav4fb4pr3wccikxvy61h4";
  };

  buildInputs = with pkgs; [
    sassc
    optipng
    inkscape
    glib
    libxml2
    gtk3
  ];

  propagatedBuildInputs = with pkgs; [
    numix-icon-theme-circle
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
  ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/icons
    ./install.sh -d $out/share/icons
  '';
}
