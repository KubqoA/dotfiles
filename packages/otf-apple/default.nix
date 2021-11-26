{ fetchurl, lib, p7zip, stdenv }:

stdenv.mkDerivation {
  name = "otf-apple";
  version = "1.0";

  buildInputs = [ p7zip ];
  src = [(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"; sha256 = "1wy3v2c87cpd9w333w78s6nn7fl5cnbsv8wff01xml6m3wgl7brz";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"; sha256 = "1wklslljf8pz3aj2lyzrnqmqyydgdwmn5ywnpssrb2r4fkb7swak";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"; sha256 = "04gznp6ynn2p67a1lgb5zgs5j4v6gcz8xh94p6f2yzbr23iih1gc";})(fetchurl {url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg"; sha256 = "1cpk6ysrj346wmm89kd35w2fv8y5z136948fll06ib3mxh1gljp4";})];

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
