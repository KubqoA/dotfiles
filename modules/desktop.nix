{ config, lib, options, ... }:

with lib;
{
  config = lib.mkIf config.desktop {
    # User settings
    user = {
      isNormalUser = true;
      extraGroups = [ "audio" "video" "networkmanager" ];
      group = "users";
      uid = 1000;
    };

    hm.home.sessionVariables = rec {
      EDITOR = "nvim";
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
      KEYTIMEOUT = 1;
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;
      BROWSER = "firefox";
      PAGER = "less";
      PATH = "$PATH:$HOME/.local/bin";
    };

    # Give the user permissions to use ‹doas›
    security.doas.extraRules = [{
      users = [ config.username ];
      noPass = true;
      keepEnv = true;
    }];

    # Make the user trusted for nix
    nix.settings = let users = [ "root" config.username ]; in {
      trusted-users = users;
      allowed-users = users;
    };

    # Enable xdg
    hm.xdg.enable = true;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;

    # Configure git with sane defaults
    hm.programs.git = {
      enable = true;
      userName = config.fullname;
      userEmail = config.email;
      signing.key = config.gpgkey;
      signing.signByDefault = true;
      ignores = [
        "/.vscode"
        ".direnv"
      ];
      aliases = {
        last = "log -1 HEAD";
      };
      extraConfig = {
        color.ui = true;
        pull.rebase = true;
        url."git@github.com:".insteadOf = [ "https://github.com/" ];
        init.defaultBranch = "main";
      };
    };

    # Configure GPG and enable SSH support for GPG keys
    hm.programs.gpg.enable = true;
    hm.services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 172800;
      maxCacheTtl = 172800;
      defaultCacheTtlSsh = 172800;
      maxCacheTtlSsh = 172800;
      pinentryFlavor = "qt";
      sshKeys = [ config.sshkey ];
    };

    # More strict SSH client settings
    hm.programs.ssh = {
      enable = true;
      extraConfig = ''
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
PubkeyAuthentication yes
UseRoaming no
VerifyHostKeyDNS ask
      '';
    };
  };
}
