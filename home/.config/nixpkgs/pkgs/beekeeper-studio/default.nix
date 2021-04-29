{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook
, wrapGAppsHook, gtk2, atomEnv, at-spi2-atk, libsecret
, libXScrnSaver, xorg, ffmpeg, libdrm, mesa
, fetchurl, lib }:

let
  version = "1.10.2";

in stdenv.mkDerivation rec {
  pname = "beekeeper-studio";
  name = "${pname}-${version}";
  system = "x86_64-linux";

  src = fetchurl {
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/beekeeper-studio_${version}_amd64.deb";
    sha256 = "5ada21ded5afd15a9fde1d02a0fe150bd4bba4b3d5cb0cbc533fe4ea1049c720";
  };

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = [
    glibc gcc-unwrapped ffmpeg gtk2 at-spi2-atk wrapGAppsHook
    atomEnv.packages libsecret libXScrnSaver xorg.libxshmfence
    libdrm mesa
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    dpkg -x $src "$out"
    mkdir "$out/bin"
    mv "$out/usr/share" "$out/share"
    rmdir "$out/usr"
    # Must rename without space otherwise patchelf breaks
    mv "$out/opt/Beekeeper Studio" "$out/opt/BeekeeperStudio"
    ln -s "$out/opt/BeekeeperStudio/beekeeper-studio" "$out/bin/${pname}"
    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace "Exec=\"/opt/Beekeeper Studio/beekeeper-studio\" %U" "Exec=$out/bin/${pname}"
  '';

  meta = with lib; {
    homepage = "https://github.com/beekeeper-studio/beekeeper-studio";
    description = "Beekeeper Studio is a cross-platform SQL editor and database manager";
    longDescription = ''
      Modern and easy to use SQL client for MySQL, Postgres, SQLite,
      SQL Server, and more. Linux, MacOS, and Windows.
    '';
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
