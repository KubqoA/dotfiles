# modules/

### [`modules/autoload`](./autoload)
Global options automatically loaded into every system and home configuration via `lib.autoloadedModules`.

### [`modules/darwin`](./darwin)
Modules specific to macOS (nix-darwin).

### [`modules/hm`](./hm)
Home Manager modules. Includes submodules like `hm/dev/*` and `hm/neovim`.

### [`modules/nixos`](./nixos)
NixOS modules. Includes `nixos/server/*` and common system-wide options.

---

Modules can be imported with the `lib.imports` with paths relative to `modules/`:

```nix
imports = lib.imports [
  "nixos/nix"
  "nixos/server/defaults"
  inputs.nixos-wsl.nixosModules.wsl # module import are also supported
  ./relative.nix                    # and relative imports as well
];
```


