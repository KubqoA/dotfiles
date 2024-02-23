{
  description = "NixOS setup with SecureBoot, LUKS encryption unlocked via TPM, and darling erasure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    lanzaboote,
    nixos-hardware,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # Sets the default formatter that is used when running
    # $ nix fmt
    formatter.${system} = pkgs.alejandra;

    # home-manager configurations defined in a flake can be enabled by running
    # $ nix run home-manager/master -- switch --flake /etc/nixos
    # or in case of username mismatch
    # $ nix run home-manager/master -- switch --flake /etc/nixos#username
    homeConfigurations.jakub = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix];
    };

    nixosConfigurations.harmonium = nixpkgs.lib.nixosSystem {
      inherit (system);
      specialArgs = {inherit system pkgs;};

      modules = [
        lanzaboote.nixosModules.lanzaboote
        nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
        ./hardware-configuration.nix

        ({
          pkgs,
          lib,
          ...
        }: {
          hardware.enableAllFirmware = true;
          nixpkgs.config.allowUnfree = true;

          networking.hostName = "harmonium"; # Define your hostname.
          networking.networkmanager.enable = true;

          # Enable the X11 windowing system.
          services.xserver.enable = true;

          # Enable the GNOME Desktop Environment.
          services.xserver.displayManager.gdm.enable = true;
          services.xserver.desktopManager.gnome.enable = true;

          environment.systemPackages = with pkgs; [
            # For debugging and troubleshooting Secure Boot.
            sbctl

            curl
            wget
            git

            # formatter
            alejandra
          ];

          programs.neovim = {
            enable = true;
            vimAlias = true;
            configure = {
              customRC = ''
                lua <<EOF
                ${pkgs.lib.readFile ./init.lua}
                EOF
              '';
              packages.myPlugins = let
                vim-bind = pkgs.vimUtils.buildVimPlugin {
                  name = "vim-bind";
                  src = pkgs.fetchFromGitHub {
                    owner = "Absolight";
                    repo = "vim-bind";
                    rev = "4967dc658b50d71568f9f80fce2d27e6a4698fc5";
                    sha256 = "0hif1r329i5mylgkcb24dl1xcn287fvy7hpfln3whv8bwmphfc77";
                  };
                };
              in
                with pkgs.vimPlugins; {
                  start = [
                    impatient-nvim # speeds up loading Lua modules
                    vim-vinegar # better netrw
                    vim-commentary # easier commenting
                    onenord-nvim # theme
                    vim-bind # better bind zone higlighting

                    (nvim-treesitter.withPlugins (plugins:
                      with plugins; [
                        tree-sitter-bash
                        tree-sitter-c
                        tree-sitter-clojure
                        tree-sitter-fennel
                        tree-sitter-haskell
                        tree-sitter-json
                        tree-sitter-lua
                        tree-sitter-markdown
                        tree-sitter-nix
                        tree-sitter-python
                        tree-sitter-typescript
                        tree-sitter-yaml
                      ]))

                    nvim-lspconfig
                  ];
                };
            };
          };

          # Enable support for nix commands and flakes
          nix.settings.experimental-features = ["nix-command" "flakes"];

          # Pinning the registry to the system pkgs on NixOS
          nix.registry.nixpkgs.flake = nixpkgs;

          # Perform garbage collection weekly to maintain low disk usage
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 1w";
          };

          # Optimize storage
          # You can also manually optimize the store via:
          #    nix-store --optimise
          # Refer to the following link for more details:
          # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
          nix.settings.auto-optimise-store = true;

          # Lanzaboote currently replaces the systemd-boot module.
          # This setting is usually set to true in configuration.nix
          # generated at installation time. So we force it to false
          # for now.
          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.loader.systemd-boot.configurationLimit = 5;
          boot.loader.efi.canTouchEfiVariables = true;

          # Enables support for secureboot, see:
          # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";
          };

          boot.initrd.systemd = {
            enable = true;
            # Required to support TPM-based unlocking of LUKS encrypted drives.
            # > sudo systemd-cryptenroll /dev/nvme0n1p6 --tpm2-device=auto --tpm2-pcrs=0+2+7
            # PCRs are important to guarantee tamper-proofing
            # Refer also to ./enable-tpm.sh
            enableTpm2 = true;
          };

          # Disables showing the generations menu, it can be still accessed when holding ‹spacebar› while booting
          # This makes the boot more "flicker free".
          boot.loader.timeout = 0;

          boot.plymouth.enable = true;

          # Darling erasure
          environment.etc = {
            nixos.source = "/persist/dotfiles";
            "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
            adjtime.source = "/persist/etc/adjtime";
            machine-id.source = "/persist/etc/machine-id";
            secureboot.source = "/persist/etc/secureboot";
          };

          systemd.tmpfiles.rules = [
            "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
            "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
            "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
            "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
          ];

          boot.initrd.systemd.services.rollback = {
            description = "Rollback BTRFS root subvolume to a pristine state";
            wantedBy = [
              "initrd.target"
            ];
            after = [
              # LUKS/TPM process
              "systemd-cryptsetup@enc.service"
            ];
            before = [
              "sysroot.mount"
            ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              mkdir -p /mnt

              # We first mount the btrfs root to /mnt
              # so we can manipulate btrfs subvolumes.
              mount -o subvol=/ /dev/mapper/enc /mnt

              # While we're tempted to just delete /root and create
              # a new snapshot from /root-blank, /root is already
              # populated at this point with a number of subvolumes,
              # which makes `btrfs subvolume delete` fail.
              # So, we remove them first.
              #
              # /root contains subvolumes:
              # - /root/var/lib/portables
              # - /root/var/lib/machines
              #
              # I suspect these are related to systemd-nspawn, but
              # since I don't use it I'm not 100% sure.
              # Anyhow, deleting these subvolumes hasn't resulted
              # in any issues so far, except for fairly
              # benign-looking errors from systemd-tmpfiles.
              btrfs subvolume list -o /mnt/root |
              cut -f9 -d' ' |
              while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
              done &&
              echo "deleting /root subvolume..." &&
              btrfs subvolume delete /mnt/root

              echo "restoring blank /root subvolume..."
              btrfs subvolume snapshot /mnt/root-blank /mnt/root

              # Once we're done rolling back to a blank snapshot,
              # we can unmount /mnt and continue on the boot process.
              umount /mnt
            '';
          };

          security.sudo.extraConfig = ''
            # rollback results in sudo lectures after each reboot
            Defaults lecture = never
          '';

          users.users.root.hashedPassword = "$6$rounds=500000$0rEHES1LTcVCJYz3$9MnsxPUjY2fcMKIHdlzZB0KW/52gPIpe9ENWcfpUlAIzG75rC3hDotfr44k7MwVVc6Ri0ePZB.q7G3xNbSvCx.";

          users.users.jakub = {
            hashedPassword = "$6$rounds=500000$0rEHES1LTcVCJYz3$9MnsxPUjY2fcMKIHdlzZB0KW/52gPIpe9ENWcfpUlAIzG75rC3hDotfr44k7MwVVc6Ri0ePZB.q7G3xNbSvCx.";
            isNormalUser = true;
            extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
          };

          system.stateVersion = "23.11";
        })
      ];
    };
  };
}
