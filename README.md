# dotfiles

![Made with trial and error](https://img.shields.io/badge/Made%20with-trial%20and%20error-blue?style=flat-square&logo=haskell)
[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

❄️ Nix flake dotfiles with support for macOS, Linux on x86 and ARM, and WSL.


## Overview

- Boilerplate free `flake.nix` thanks to custom bootstrap module [→](./bootstrap.nix)
- Custom lib extensions [→](./lib.nix)
- Global auto-loaded config [→](./modules/autoload/config.nix)

### macOS
- Sane system defaults [→](./modules/darwin/base.nix)
- Declarative homebrew packages [→](./modules/darwin/homebrew.nix)
- Custom app icons support [→](./modules/darwin/icons.nix)

### NixOS
- Darling erasure based on BTRFS snapshots and [impermanence](https://github.com/nix-community/impermanence) [→](./modules/nixos/impermanence.nix)
- Declarative disk management using [disko](https://github.com/nix-community/disko) [→](./hosts/organ/system/disko.nix)
- Remote installation support using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) [→](https://github.com/KubqoA/dotfiles/blob/main/hosts/organ/README.md#setup)
- Containerized services using [quadlet-nix](https://github.com/SEIAROTg/quadlet-nix) [→](./hosts/organ/containers)

### home-manager
- Neovim setup with LSP, tree-sitter, and more [→](./modules/hm/neovim/default.nix)
- Fast fish shell setup [→](./modules/hm/fish.nix)

## Principles
- Keep it simple, try to not introduce overly complicated boilerplate
- Make module loading explicit, and loading a module = enabling it
- Keep things formatted with [`alejandra`](https://github.com/kamadorueda/alejandra)


## To-Do
- [ ] Finish Wayland based setup for harmonium


## Useful resources
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix language basics](https://nix.dev/tutorials/nix-language)
- [Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- [NixOS Modules Lessons](https://nixos-modules.nix.みんな/)
- [Nixpkgs Functions reference](https://nixos.org/manual/nixpkgs/stable/#chap-functions)
- [Nix Expression Language](https://nixos.org/manual/nix/stable/#ch-expression-language)

**Option search**
- [Home Manager Option Search](https://home-manager-options.extranix.com/)
- [Nix Darwin Option Search](https://options.nix-darwin.uz/)

**Other dotfiles**
- [my old dotfiles](https://github.com/KubqoA/dotfiles/tree/old)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)

