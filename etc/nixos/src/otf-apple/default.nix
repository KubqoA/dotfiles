{ pkgs ? import <nixpkgs> { }

, stdenv ? pkgs.stdenv
, lib ? pkgs.lib
, fetchurl ? pkgs.fetchurl
, p7zip ? pkgs.p7zip
}:

stdenv.mkDerivation {
  name = "otf-apple";
  version = "1.0";

  buildInputs = [ p7zip ];

  src = [
    (fetchurl {
      url = "https://developer.apple.com/design/downloads/SF-Font-Pro.dmg";
      sha256 = "c0b158d8d777ef65cee37a86822d5adcefa730e1c5da115e41c5f1b4e3a83986";
    })
    (fetchurl {
      url = "https://developer.apple.com/design/downloads/SF-Mono.dmg";
      sha256 = "fe04fe76d4f3847dc401566c47de14c0d14679d624680671b5d03938bf2ca22f";
    })
    (fetchurl {
      url = "https://developer.apple.com/design/downloads/SF-Font-Compact.dmg";
      sha256 = "5e53392ef1bdd17b8daf940745bcc85ad9f01c975eaf1e812a5c0a2d67897ec5";
    })
    (fetchurl {
      url = "https://developer.apple.com/design/downloads/NY-Font.dmg";
      sha256 = "58058b5dbddb77eec84a0c0b10b41fc544bc7cd50c6cb49874da4197f91afde5";
    })
  ];

  sourceRoot = "./";

  preUnpack = "mkdir fonts";

  unpackCmd = ''
    7z x $curSrc >/dev/null
    dir="$(find . -not \( -path ./fonts -prune \) -type d | sed -n 2p)"
    cd $dir 2>/dev/null
    7z x *.pkg >/dev/null
    7z x Payload~ >/dev/null
    mv Library/Fonts/*.otf ../fonts/
    cd ../
    rm -R $dir
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/{SF\ Pro,SF\ Mono,SF\ Compact,New\ York}
    cp -a fonts/SF-Pro*.otf $out/share/fonts/opentype/SF\ Pro
    cp -a fonts/SF-Mono*.otf $out/share/fonts/opentype/SF\ Mono
    cp -a fonts/SF-Compact*.otf $out/share/fonts/opentype/SF\ Compact
    cp -a fonts/NewYork*.otf $out/share/fonts/opentype/New\ York
  '';
}
