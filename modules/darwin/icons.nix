# Make sure the terminal has Full Disk Access, otherwise this might fail.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.icons;
in {
  options.my.icons = mkOption {
    type = types.attrsOf types.path;
    default = {};
    example = literalExpression ''
      {
        "/Applications/Notion.app" = ./icons/notion.icns;
      }
    '';
    description = ''
      Attribute set of paths to applications and their corresponding icon files.
      The icon files should be in .icns format.
    '';
  };

  config = mkIf (cfg != {}) {
    homebrew.brews = ["fileicon"];

    system.activationScripts.postActivation.text = let
      iconsList =
        mapAttrsToList (path: icon: {
          inherit path icon;
        })
        cfg;
    in ''
      set -e
      set -o pipefail
      export PATH="${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:@out@/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin"

      if ! command -v /opt/homebrew/bin/fileicon >/dev/null 2>&1; then
        echo "fileicon not found, make sure it's installed with homebrew"
        exit 1
      fi

      ${concatMapStringsSep "\n" (item: ''/opt/homebrew/bin/fileicon set "${item.path}" "${item.icon}"'') iconsList}

      echo "clearing iconcache and restarting Dock..."
      rm /var/folders/*/*/*/com.apple.dock.iconcache
      killall Dock
    '';
  };
}
