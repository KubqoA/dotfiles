# common packages shared across all systems
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    age
    alejandra
    curl
    git
    jq
    nerdfetch
    neovim
    nil
    nurl
    ripgrep
    sops
    tldr
    wget
  ];
}
