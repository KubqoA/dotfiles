# Usage:
# ```
# import ./bootstrap.nix inputs {
#   <system> = ["hostname1" "hostname2"];
# }
# ```
# For each system defines:
# - `alejandra` as the default formatter
# - `nix develop` shell for easily activating configs on new machines
#
# And for each host in a system defines:
# - darwin or nixos system config imported from `./hosts/${hostname}`
# - home-manager config for every user `./homes/${hostname}/${username}.nix` as `${username}@${hostname}`
#
# The darwin system config receives all home-manager configs of the host as `homes`,
# so it can create the users and install their homebrew packages.
#
# Both configs also get:
# - custom `lib` from `./lib.nix`
# - all autoloaded modules `./modules/autoload`
inputs @ {
  nixpkgs,
  self,
  ...
}: systems: let
  # system agnostic lib with custom extensions
  lib = nixpkgs.lib.extend (import ./lib.nix inputs);

  inherit (lib) attrNames filterAttrs foldl hasSuffix mapAttrsToList mapToAttrs recursiveUpdate removeSuffix;

  # Home-manager configs of a host, keyed by their flake output name.
  # Every top-level `.nix` file in `./homes/${hostname}` is a user, subdirectories are
  # ignored as they are regular modules imported by the home configs.
  hostHomes = hostname: let
    dir = ./homes/${hostname};
    usernames = map (removeSuffix ".nix") (attrNames (filterAttrs
      (file: type: type == "regular" && hasSuffix ".nix" file)
      (builtins.readDir dir)));
  in
    mapToAttrs (username: {
      name = "${username}@${hostname}";
      value.modules = [(dir + "/${username}.nix") {inherit username;}];
    })
    usernames;

  mapSystem = system: hostnames: let
    pkgs = nixpkgs.legacyPackages.${system};

    systemSpecifics =
      if pkgs.stdenv.hostPlatform.isDarwin
      then {
        fn = lib.darwinSystem;
        option = "darwinConfigurations";
        command = "sudo nix run nix-darwin --";
      }
      else {
        fn = lib.nixosSystem;
        option = "nixosConfigurations";
        command = "sudo nixos-rebuild";
      };

    mkHome = name: homeName: {modules}:
      lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit homeName inputs name lib system;};
        modules = modules ++ lib.autoloadedModules;
      };

    homes =
      mapToAttrs (name: {
        inherit name;
        value = lib.mapAttrs (mkHome name) (hostHomes name);
      })
      hostnames;

    mkHost = name: {
      inherit name;
      value = systemSpecifics.fn {
        inherit system;
        specialArgs = {
          inherit inputs lib name self system;
          homes = builtins.attrValues homes.${name};
        };
        modules = [./hosts/${name}] ++ lib.autoloadedModules;
      };
    };
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
        echo -e "        Homes: \e[36m${builtins.concatStringsSep "\\e[0m, \\e[36m" (lib.concatMap attrNames (builtins.attrValues homes))}\e[0m"
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
    ${systemSpecifics.option} = mapToAttrs mkHost hostnames;
    homeConfigurations = foldl (a: b: a // b) {} (builtins.attrValues homes);
  };

  configuration = foldl recursiveUpdate {} (mapAttrsToList mapSystem systems);
in
  configuration // {inherit lib;}
