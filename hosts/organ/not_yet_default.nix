#                              
#   ___  _ __ __ _  __ _ _ __  
#  / _ \| '__/ _` |/ _` | '_ \ 
# | (_) | | | (_| | (_| | | | |
#  \___/|_|  \__, |\__,_|_| |_|
#            |___/             
#

{ ... }:

{
  networking.domain = "jakubarbet.me";
  environment.noXlibs = true;

  modules = {
    services = {
      nginx.enable = true;
      openssh.enable = true;
    };
  };
}
