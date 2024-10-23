# lib

Library has three important functions:

1. Moves configuration boilerplate out of the main `flake.nix` by providing an abstraction to define
   home-manager and system configurations. For each defined system architecture it configures:
   - `nix fmt` - Alejandra formatter
   - `nix develop` - custom shell with `hm` and `os` aliases for activating the configurations

2. Autoloads [`config.nix`](../config.nix), [agenix](https://github.com/ryantm/agenix),
   and [`autoloaded modules`](../modules/autoload) for all home-manager and system configurations

3. Extends the default lib by loading all `.nix` file in the `lib` directory under the `_` namespace

## Configuration abstraction
```nix
import ./lib inputs {
  <architecture> = {
    homes.<name> = path;
    systems.<name> = path;
  };
}
```

## `lib` extensions

### `lib._.moduleImports`
Helper to make it easier to import modules from the `modules` directory.
Automatically includes `.nix` suffix for supplied paths, where necessary.

```nix
{lib, ...}: {
  imports = lib._.moduleImports [
    "common/git"
    "common/zsh"
    # ...
  ];
}
```

### `lib._.autoloadedModules`
Helper to autoload modules from the `modules/autoload` directory.
Automatically used when creating home-manager and system configurations.

### `lib._.defineSecrets`
Helper to define agenix secrets in a more concise way.

```nix
{lib, ...}: {
  age.secrets = lib._.defineSecrets ["secret1" "secret2"] {
    secret3 = {owner = "foobar";};
  };

  # produces equivalent configuration to
  # age.secrets = {
  #   secret1.file = ../secrets/secret1.age;
  #   secret2.file = ../secrets/secret2.age;
  #   secret3 = {
  #     file = ../secrets/secret3.age;
  #     owner = "foobar";
  #   };
  # }
}
```
