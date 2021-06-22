{ lib, fetchurl, appimageTools }:

let
  version = "1.0.0-beta.85";
  
in appimageTools.wrapType2 rec {
  name = "athens";
  src = fetchurl {
    url = "https://github.com/athensresearch/athens/releases/download/v${version}/Athens-${version}.AppImage";
    sha256 = "017k3l3wvq8jvlgiic2jmbxadndm9gcsd6wjy5m48mm45030095k";
  };

  extraPkgs = (pkgs: with pkgs; with xorg; [ libxshmfence ]);

  extraInstallCommands = 
    let appimageContents = appimageTools.extractType2 { inherit name src; }; in
    ''
      install -Dm644 ${appimageContents}/athens.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/athens.desktop \
          --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name}'
      install -Dm644 ${appimageContents}/athens.png $out/share/icons/hicolor/256x256/apps/${name}.png
  '';

  meta = with lib; {
    homepage = "https://github.com/athensresearch/athens";
    description = "Athens is a knowledge graph for research and notetaking.";
    longDescription = ''
      Athens is a knowledge graph for research and notetaking.
      Athens is open-source, private, extensible, and community-driven.
    '';
    license = licenses.epl10;
    platforms = [ "x86_64-linux" ];
  };
}
