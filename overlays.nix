final: prev: {
  #  python312 = prev.python312.override {
  #    packageOverrides = final: prev: {
  #      pyopenssl = prev.pysaml2.overridePythonAttrs (orig: rec {
  #        version = "24.3.0";
  #        src = prev.fetchFromGitHub {
  #          owner = "pyca";
  #          repo = "pyopenssl";
  #          rev = "refs/tags/${version}";
  #          hash = "sha256-/TQnDWdycN4hQ7ZGvBhMJEZVafmL+0wy9eJ8hC6rfio=";
  #        };
  #      });
  #    };
  #  };
}
