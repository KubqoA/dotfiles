{ config, lib, ... }:

{
  # tmpfs = /tmp is mounted in ram.
  boot.tmpOnTmpfs = lib.mkDefault true;
  boot.cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
  boot.loader.systemd-boot.editor = false;

  # Swap ‹sudo› for ‹doas›
  security.doas.enable = true;
  security.sudo.enable = false;
  environment.shellAliases = {
    sudo = "doas";
  };
}
