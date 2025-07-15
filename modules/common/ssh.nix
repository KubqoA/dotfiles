# [home-manager]
{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks.organ = {
      hostname = "organ.jakubarbet.me";
      user = "jakub";
      extraOptions.VerifyHostKeyDNS = "yes";
    };
  };
}
