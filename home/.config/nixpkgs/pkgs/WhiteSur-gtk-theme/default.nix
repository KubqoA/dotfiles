{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, fetchFromGitHub ? pkgs.fetchFromGitHub
# options
, alt ? "standard"
, theme ? "default"
, panel ? "default"
, size ? "default"
}:

stdenv.mkDerivation rec {
  name = "WhiteSur-gtk-theme";
  pname = "WhiteSur-gtk-theme";
  version = "2021-01-15";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "15fsfd9d4xnkf84z9560qk5fcb6fc9887nnlk9n0pimwzvqvhbc2";
  };

  buildInputs = with pkgs; [
    gtk-engine-murrine
    sassc
    optipng
    inkscape
    glib
    libxml2
  ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';
}
