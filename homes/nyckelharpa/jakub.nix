{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/gpg"
    "hm/macos"
    "hm/password-store"
    "hm/ssh"
    "hm/dev/js"
    "hm/dev/php"
    "hm/dev/python"
    "hm/dev/ruby"
    "hm/dev/rust"
  ];

  my = {
    dock = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
      "/Applications/WhatsApp.app"
    ];
    uuid = "9A95453F-92B5-4C37-98FD-7809C8B7CE44";
  };

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
