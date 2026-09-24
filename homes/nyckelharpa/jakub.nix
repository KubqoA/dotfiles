{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/gpg"
    "hm/password-store"
    "hm/ssh"
    "hm/dev/js"
    "hm/dev/php"
    "hm/dev/python"
    "hm/dev/ruby"
    "hm/dev/rust"
  ];

  programs = {
    eza.enable = true;
  };

  # Installed system-wide by the nyckelharpa darwin config
  homebrew = {
    brews = ["cloudflare-wrangler"];
    casks = [
      "google-chrome"
      "iina"
      "steam"
      "whatsapp"
    ];
  };
}
