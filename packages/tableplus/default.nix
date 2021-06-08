{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook
, libgee, gtksourceview3, libsecret, openldap, json-glib
, cairo, pango, lib }:

let
  version = "0.1.84";
  src = builtins.path { path = ./tableplus_0.1.84_amd64.deb; name = "tableplus.deb"; };

in stdenv.mkDerivation rec {
  pname = "tableplus";
  name = "${pname}-${version}";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = [
    glibc
    gcc-unwrapped
    libgee
    libsecret
    openldap
    json-glib
    gtksourceview3
    cairo
    pango
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p "$out/bin" "$out/share/icons/hicolor/256x256/apps" "$out/share/applications"
    dpkg -x $src "$out"
    cp -av "$out/opt/tableplus/tableplus" "$out/opt/tableplus/resource" "$out/bin"
    install -Dm644 "$out/opt/tableplus/resource/image/logo.png" "$out/share/icons/hicolor/256x256/apps/${pname}.png"
    install -Dm644 "$out/opt/tableplus/tableplus.desktop" "$out/share/applications/${pname}.desktop"
    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace "Exec=/usr/local/bin/tableplus" "Exec=$out/bin/tableplus"
    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace "Icon=/opt/tableplus/resource/image/logo.png" "Icon=${pname}"
    echo "" >> "$out/share/applications/${pname}.desktop"
    echo "Comment=Modern, native, and friendly GUI tool for relational databases" >> "$out/share/applications/${pname}.desktop"
    echo "Categories=Development;" >> "$out/share/applications/${pname}.desktop"
    echo "StartupWMClass=${pname}" >> "$out/share/applications/${pname}.desktop"
    rm -rf "$out/opt"
  '';

  meta = with lib; {
    homepage = "https://tableplus.com/";
    description = "Database management made easy";
    longDescription = ''
      Modern, native, and friendly GUI tool for relational databases:
      MySQL, PostgreSQL, SQLite & more
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
