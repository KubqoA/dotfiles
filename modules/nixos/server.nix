{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.server;
in {
  imports = [inputs.srvos.nixosModules.server];

  options.my.server = with lib; {
    domain = mkOption {type = types.str;};
  };

  config = {
    # add default ssh public keys for the default user
    users.users.${config.username}.openssh.authorizedKeys.keys = config.sshPublicKeys;

    networking.domain = cfg.domain;

    environment.systemPackages = [pkgs.ghostty.terminfo];

    # overrides for srvos config
    srvos = {
      detect-hostname-change.enable = false;
      update-diff.enable = false;
    };

    programs = {
      vim = {
        enable = false;
        defaultEditor = false;
      };
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };
  };
}
