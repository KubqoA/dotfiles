# dotfiles

![Made with trial and error](https://img.shields.io/badge/Made%20with-trial%20and%20error-blue?style=flat-square&logo=haskell)
[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

Currently transitioning to a new setup, the old dotfiles can be found in the [`old` branch](https://github.com/KubqoA/dotfiles/tree/old).

NixOS dotfiles with support for:
- Darling erasure - restoring the machine to a clean state on every boot
- Secureboot via [lanzaboote](https://github.com/nix-community/lanzaboote)
- LUKS encryption with TPM unlocking
- Flicker-free boot with Plymouth
- Sensible defaults for garbage collection to reduce disk usage

Further the dotfiles include:
- Home-manager setup for both NixOS and MacOS
- `nix-darwin` setup, with Homebrew support
- Formatting with [`alejandra`](https://github.com/kamadorueda/alejandra)
- Minimal ZSH setup

## Usage
The dotfiles contain configuration for:
- [harmonium](./hosts/harmonium) - Personal NixOS laptop setup
- [organ](./hosts/organ) - ARM-based server
- [nyckelharpa](./hosts/nyckelharpa) - Work MacOS setup
- home-manager configurations for both systems

Refer to the respective host directories for more information.

## To-Do
- [x] Modularize the setup
- [ ] Custom Sway/[newm-atha](https://sr.ht/~atha/newm-atha/) based desktop setup
- [ ] Docker support
- [ ] Dev environments
- [ ] Full Neovim setup
- [ ] Full nix-darwin setup with system configuration

## Useful resources
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix language basics](https://nix.dev/tutorials/nix-language)
- [Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- [Quick Start: NixOS Secure Boot](https://github.com/nix-community/lanzaboote)
- [Nixpkgs Functions reference](https://nixos.org/manual/nixpkgs/stable/#chap-functions)
- [Nix Expression Language](https://nixos.org/manual/nix/stable/#ch-expression-language)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles), which are a great learning resource
