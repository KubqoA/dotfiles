{ stdenv, fetchFromGitHub, lib, gtk-engine-murrine
, sassc, optipng, inkscape, glib, libxml2
# options
, alt ? "standard"
, theme ? "default"
, panel ? "default"
, size ? "default"
}:

stdenv.mkDerivation rec {
  name = "WhiteSur-gtk-theme";
  pname = "WhiteSur-gtk-theme";
  version = "2021-03-08";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "01xbs6fa847xrfv8k4knx5gq0sp0wirn1ijmaj6j99q0gv3lnqkg";
  };

  buildInputs = [
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
