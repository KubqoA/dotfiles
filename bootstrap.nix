# Turns the abstract per system configuration in ‹flake.nix› to individual
# nixos, darwin and home-manager configs. Additionally for each system architecture
# defines formatting with ‹nix fmt› and a custom ‹nix develop› shell with helpers
# for activating configurations on new machines. Also defines a custom lib with
# extensions defined in ‹lib.nix›.
#
# For all nixos, darwin, and home-manager config autoloads ‹config.nix›, agenix, and
# all autoloaded modules.
#
# Usage:
# ```
# import ./bootstrap.nix inputs {
#   <architecture> = ["hostname1" "hostname2"];
# }
# ```
inputs @ {
  nixpkgs,
  self,
  sops-nix,
  ...
}: systems: let
  # system agnostic lib with custom extensions
  lib = nixpkgs.lib.extend (import ./lib.nix inputs);

  inherit (lib) foldl recursiveUpdate mapAttrsToList;

  mapSystem = system: hostnames: let
    pkgs = nixpkgs.legacyPackages.${system};

    systemSpecifics =
      if pkgs.stdenv.isDarwin
      then {
        fn = lib.darwinSystem;
        option = "darwinConfigurations";
        command = "sudo nix run nix-darwin --";
        sopsModule = sops-nix.darwinModules.sops;
      }
      else {
        fn = lib.nixosSystem;
        option = "nixosConfigurations";
        command = "sudo nixos-rebuild";
        sopsModule = sops-nix.nixosModules.sops;
      };

    mapHosts = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = systemSpecifics.fn {
          inherit system;
          specialArgs = {
            inherit inputs lib self system;
            hostName = hostname;
          };
          modules = [./hosts/${hostname} systemSpecifics.sopsModule] ++ lib.autoloadedModules;
        };
      })
      hostnames);

    mapHomes = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs lib system;
            homeName = hostname;
          };
          modules = [./homes/${hostname} sops-nix.homeManagerModules.sops] ++ lib.autoloadedModules;
        };
      })
      hostnames);
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [alejandra home-manager ruby_3_4 ssh-to-age];
      # When setting PS1, it is automatically prefixed with `(nix:$name)\040\n`, so exporting custom PS1 in a PROMPT_COMMAND is a hack around that.
      shellHook = ''
        unset PS1
        export PROMPT_COMMAND='export PS1="\n\[\e[1;36m\]nix-develop\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;35m\]❯\[\e[0m\] "'
        echo
        echo -e "\e[1mAvailable Commands:\e[0m"
        echo -e "  \e[1;33m‹os›\e[0m  → Apply system configuration"
        echo -e "        Hosts: \e[36m${builtins.concatStringsSep "\\e[0m, \\e[36m" hostnames}\e[0m"
        echo
        echo -e "  \e[1;33m‹hm›\e[0m  → Apply home-manager configuration"
        echo -e "        Hosts: \e[36m${builtins.concatStringsSep "\\e[0m, \\e[36m" hostnames}\e[0m"
        echo
        echo -e "  \e[1;33m‹ssh-key-setup›\e[0m → SSH key setup"
        echo
        echo -e "\e[90mSystem: ${system}\e[0m"

        hm() {
          home-manager switch --flake .#$1
        }

        os() {
          ${systemSpecifics.command} switch --flake .#$1
        }

        export PATH="$PATH:$(pwd)/scripts"
      '';
    };
    ${systemSpecifics.option} = mapHosts;
    homeConfigurations = mapHomes;
  };

  configuration = foldl recursiveUpdate {} (mapAttrsToList mapSystem systems);
in
  configuration // {inherit lib;}
