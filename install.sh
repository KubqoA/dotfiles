#!/bin/sh

# Goals:
# encrypted BTRFS with opt-in state on NixOS defined by flakes with secureboot and user managed home-manager config

# Overall
# Inputs:
# * designated swap and main partition
# * encryption password
# * hostname

# Step 1 - Prepare disks
# Inputs: designated swap and main partition, encryption password
# Outputs:
# * LUKS encrypted swap
# * LUKS encrypted main partition, BTRFS with default layout as outlined in:
#   https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

# Step 2 - hardware-configuration.nix
# Inputs: prepared disks
# Outputs:
# * nixos-generate-config --root /mnt -> hardware-configuration.nix
# * modified hardware-configuration.nix for proper BTRFS settings

# Step 3 - Prepare config
# Inputs: hostname, optional template hostname
# Outputs:
# * clones https://github.com/KubqoA/dotfiles
# * takes hosts/hostname and updates hardware-configuration.nix
#   * if hosts/hostname doesn't exist, copies hosts/template

# Step 4 - Install NixOS

# Step 5 - Enter NixOS
# generate secureboot keys with sbctl

# Step 6 - Su as user

# Step 7 - home init
# Home-manager init
# Imports GPG key
# Syncs password store

# After first boot
# Enable TPM LUKS unlock with
# # systemd-cryptenroll /dev/nvme0n1p6 --tpm2-device=auto --tpm2-pcrs=0+2+7
