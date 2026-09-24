{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/password-store"
  ];

  programs.fish.art = null;
}
