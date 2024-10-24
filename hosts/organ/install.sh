#!/bin/sh

organ_dir="$(dirname "$0")"
networking_conf="$organ_dir/networking.nix"
ipv4=$(sed -n 's/.*ipv4 = "\(.*\)".*/\1/p' "$networking_conf")
ipv6=$(sed -n 's/.*ipv6 = "\(.*\)".*/\1/p' "$networking_conf")

nix run github:nix-community/nixos-anywhere -- \
  --build-on-remote \
  --copy-host-keys \
  --flake ".#organ" \
  root@$ipv4
