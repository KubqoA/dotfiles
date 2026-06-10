{...}: {
  homebrew = {
    taps = [
      "puma/puma"
    ];

    brews = [
      "autoconf"
      "gmp"
      "jemalloc"
      "libsodium"
      "libyaml"
      "openssl@3.5"
      "python-setuptools"
      "readline"
      "vips"
      {
        name = "libiconv";
        link = true;
      }
      "puma/puma/puma-dev"
    ];

    casks = ["rubymine"];
  };
}
