{pkgs, ...}: {
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      python312 = prev.python312.override {
        packageOverrides = final: prev: {
          # Changes taken from
          # https://github.com/NixOS/nixpkgs/pull/369550
          pysaml2 = prev.pysaml2.overridePythonAttrs (orig: rec {
            disabledTests = [
              # Disabled tests try to access the network
              "test_load_extern_incommon"
              "test_load_remote_encoding"
              "test_load_external"
              "test_conf_syslog"

              # Caused by pyopenssl update to 24.3.0
              # https://github.com/IdentityPython/pysaml2/issues/975
              "test_encrypted_response_6"
              "test_validate_cert_chains"
              "test_validate_with_root_cert"
            ];
            meta.broken = false;
          });
        };
      };
    })
  ];
}
