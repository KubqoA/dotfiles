{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/ssh"
    "hm/dev/js"
  ];
}
