{ stdenv, fetchFromGitHub, lib, sassc, optipng
, inkscape, glib, libxml2, gtk3, numix-icon-theme-circle
, gnome3, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  name = "WhiteSur-icon-theme";
  pname = "WhiteSur-icon-theme";
  version = "2021-03-03";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "b3cfb6f66a9485ef48be028212d1bbd182093137";
    sha256 = "1zhiiv6i9idzkb3pnn6s7hdp3bz0wspw2arbax28yhpc2i08bfiw";
  };

  buildInputs = [
    sassc
    optipng
    inkscape
    glib
    libxml2
    gtk3
  ];

  propagatedBuildInputs = [
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
