# dotfiles

![Made with trial and error](https://img.shields.io/badge/Made%20with-trial%20and%20error-blue?style=flat-square&logo=haskell)
[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

❄️ Nix flake dotfiles with support for:
- macOS and Linux on both x86 and ARM
- home-manager for both macOS and NixOS


## Overview

### macOS setup:
[system](./hosts/nyckelharpa) · [home](./homes/jakub-macos)

- Declarative homebrew packages [→](./hosts/nyckelharpa/homebrew.nix)
- Sane system defaults [→](./hosts/nyckelharpa/system.nix)
- Custom app icons support [→](./modules/darwin/icons.nix)


### NixOS laptop setup:
[system](./hosts/harmonium) · [home](./homes/jakub-linux)

- Darling erasure - restoring the machine to a clean state on every boot
- Secureboot via [lanzaboote](https://github.com/nix-community/lanzaboote)
- LUKS encryption with TPM unlocking
- Flicker-free boot with Plymouth
- Work in progress Wayland setup

### NixOS server setup:
[system](./hosts/organ) · [home](./homes/jakub-server)

- Declarative disk management using [disko](https://github.com/nix-community/disko) [→](./hosts/organ/disko.nix)
- Remote installation support using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) [→](https://github.com/KubqoA/dotfiles/blob/main/hosts/organ/README.md#setup)
- Web server, mail server, Seafile, self-hosted DNS, Tailscale, Syncthing, ...


## Principles
- Keep it simple, try to not introduce overly complicated boilerplate
- Document any new concepts to make them understandable for me in a year
- Make module loading explicit, and loading a module = enabling it
- Keep things formatted with [`alejandra`](https://github.com/kamadorueda/alejandra)


## To-Do
- [ ] Fix ZSH setup - improve startup performance, proper cache busting
- [ ] Full Neovim setup
- [ ] Custom Sway/Hyperland based setup for personal laptop
- [ ] Better split NixOS laptop config


## Useful resources
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix language basics](https://nix.dev/tutorials/nix-language)
- [Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- [Quick Start: NixOS Secure Boot](https://github.com/nix-community/lanzaboote)
- [Nixpkgs Functions reference](https://nixos.org/manual/nixpkgs/stable/#chap-functions)
- [Nix Expression Language](https://nixos.org/manual/nix/stable/#ch-expression-language)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [my old dotfiles](https://github.com/KubqoA/dotfiles/tree/old)
