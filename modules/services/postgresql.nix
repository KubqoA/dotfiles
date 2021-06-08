{ config, options, lib, pkgs, ... }:

with lib;
let
  inherit (builtins) attrNames listToAttrs map;
  cfg = config.modules.services.postgresql;
in {
  options.modules.services.postgresql = {
    enable = _.mkBoolOpt false;
    databases = _.mkOpt (types.listOf types.str) [] "Databases that must exist";
    autoUserForDatabase = _.mkBoolOpt true;
    users = mkOption {
      type = types.attrs;
      default = {};
      example = {
        johndoe = [ "database" ];
      };
      description = ''
        Ensures that the specified users have access to the databases.
        Uses <option>services.postgresql.ensureUsers</option>.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      authentication = mkIf config.localMachine (lib.mkForce ''
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
      '');
      ensureDatabases = cfg.databases;
      ensureUsers = let
        allPrivileges = database: nameValuePair "DATABASE ${database}" "ALL PRIVILEGES";
        databasesToPermissions = databases: listToAttrs (map allPrivileges databases);
        extraUsers = if cfg.autoUserForDatabase then listToAttrs (map (x: nameValuePair x [x]) cfg.databases) else {};
        users = recursiveUpdate extraUsers cfg.users;
        databaseUser = user: { name = user; ensurePermissions = databasesToPermissions users.${user}; };
      in map databaseUser (attrNames users);
    };
  };
}
