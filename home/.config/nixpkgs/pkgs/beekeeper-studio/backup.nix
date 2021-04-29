{ lib, fetchurl, appimageTools, makeDesktopItem }:

let
  version = "1.10.2";
  
in appimageTools.wrapType2 rec {
  name = "beekeeper-studio";
  src = fetchurl {
    name = "Beekeeper-Studio-${version}.AppImage";
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}.AppImage";
    sha256 = "f12938b6d3b19b5c4fcd706172e6590e8c7756a25773fe7e6c371fd2b25f55fc";
  };

  extraInstallCommands = 
    let appimageContents = appimageTools.extractType2 { inherit name src; }; in
    ''
      install -Dm644 ${appimageContents}/beekeeper-studio.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/beekeeper-studio.desktop \
          --replace 'Exec=AppRun %U' 'Exec=${name}'
      install -Dm644 ${appimageContents}/beekeeper-studio.png $out/share/icons/hicolor/256x256/apps/${name}.png
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