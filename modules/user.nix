{ config, inputs, lib, options, ... }:

with lib;
{
  options = with types; {
    user = mkOption {
      type = attrs;
      default = {};
      example = {
        packages = [ pkgs.neovim ];
      };
      description = ''
        An alias for passing option to the default user via the option
        <option>users.user.<name></option>.
      '';
    };
    home = {
      file = mkOption {
        type = attrs;
        default = {};
        description = "Files managed by home-manager's <option>home.file</option>";
      };
      configFile = mkOption {
        type = attrs;
        default = {};
        description = "Files managed by home-manager's <option>xdg.configFile</option>";
      };
      _ = mkOption {
        type = attrs;
        default = {};
        description = "For passing arbitrary configuration to user's home-manager config";
      };
    };
    localMachine = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether this is a local machine or not. On local machine we can for
        example enable the <literal>noPass = true;</literal> rule in
        <option>security.doas.extraRules</option> for the user, or several
        other relaxations that are not recommended for a server environment.
      '';
    };
    dotfiles = let 
      t = either str path;
    in {
      dir = _.mkOpt t 
        (findFirst pathExists (toString ../.) [
          "${config.user.home}/.config/dotfiles"
          "/etc/dotfiles"
        ])
        "The root directory of the dotfiles";
      binDir = _.mkOpt' t "${config.dotfiles.dir}/bin";
      configDir = _.mkOpt' t "${config.dotfiles.dir}/config";
    };
    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v: if isList v
               then concatMapStringsSep ":" (x: toString x) v
               else (toString v));
      default = {};
      description = "Maps environment variables";
    };
  };

  config = {
    # Defines the default user.
    user =
      let
        defaultName = "jarbet";
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then defaultName else user;
      in {
        inherit name;
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
        # If we are on a local machine the ‹wheel› group is not necessary
        # because a special ‹doas› rule will be created.
        extraGroups = if !config.localMachine then [ "wheel" ] else [];
      };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    home._ = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
    };

    home-manager.useUserPackages = true;
    home-manager.users.${config.user.name} = mkAliasDefinitions options.home._;

    security.doas.extraRules = if config.localMachine
      then [ { users = [ config.user.name ]; noPass = true; keepEnv = true; } ]
      else [];

    nix = let users = [ "root" config.user.name ]; in {
      trustedUsers = users;
      allowedUsers = users;
    };

    environment = {
      sessionVariables = {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_BIN_HOME    = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop
        XDG_DESKTOP_DIR = "$HOME";
      };
      variables = {
        # Make some programs "XDG" compliant
        LESSHISTFILE    = "$XDG_CACHE_HOME/lesshst";
        WGETRC          = "$XDG_CONFIG_HOME/wgetrc";
      };
      extraInit =
        concatStringsSep "\n"
          (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
    };
  };
}
