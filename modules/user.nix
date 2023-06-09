{ config, lib, ... }:

with lib;
{
  options = with types; {
    userName = _.mkOpt str "jakub" "The username for a default user";
  };

  config = {
    # User settings
    users.users.${config.userName} = {
      isNormalUser = true;
      uid = 1000;
    };

    # Give the user permissions to use ‹doas›
    security.doas.extraRules = [{
      users = [ config.userName ];
      keepEnv = true;
    }];
  };
}
