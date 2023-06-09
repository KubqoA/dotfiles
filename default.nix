{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) _;
in {
  #imports = _.attrValuesRec (_.mapModulesRec ./modules import);
  imports =
    [ inputs.home-manager.nixosModules.home-manager ]
    ++ _.attrValuesRec (_.mapModulesRec ./modules import);

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.systemPackages = with pkgs; [
    curl git wget neovim efibootmgr
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  
  system.stateVersion = lib.mkDefault "23.05";
  hm.home.stateVersion = lib.mkDefault "23.05";
}
