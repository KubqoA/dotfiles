{ stdenv, lib, callPackage, fetchurl, isInsiders ? false }:

  callPackage ./generic.nix rec {
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "insiders";
    pname = "vscode";

    executableName = "code-insiders";
    longName = "Visual Studio Code - Insiders";
    shortName = "Code - Insiders";

    src = fetchurl {
      name = "VSCode_insider_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      sha256 = "18ac59ysh0f95g0d4n4hq8a7x7p8rza070casmirq0cfszmq3a51";
    };

    sourceRoot = "";

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = "https://code.visualstudio.com/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }


