![Organ](./organ.jpg)

<sub><sup>Photo by <a href="https://unsplash.com/@haozlife?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Hao Zhang</a> on <a href="https://unsplash.com/photos/man-playing-brown-musical-instrument-dFpDCSECapg?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a></sup></sub>

# organ
ARM-based server running on Hetzner cloud

## Setup
Get from a new Hetzner Cloud VPS to a ready-system.

1. Create a new server on Hetzner Cloud
  - Tested with Ubuntu 24.04
  - Arm64 architecture
  - Assign an IPv4 and IPv6 address
  - Add your SSH key
2. Update [`networking.nix`](./networking.nix) with the correct IP addresses
3. Convert the SSH Ed25519 public key of the server to the age format
  ```sh
  nix-shell -p ssh-to-age --run 'ssh-keyscan <server-ip> | ssh-to-age'
  ```
4. Update [`.sops.yml`](../../.sops.yaml) with the age key
5. Re-key secrets as needed
  ```sh
  sops updatekeys hosts/organ/secrets.yaml
  ```
6. Start the install
  ```sh
  ./hosts/organ/install.sh
  ```
7. After install finishes, login as the configured user
  ```sh
  ssh jakub@<server-ip>
  ```
8. Clone the dotfiles to `/persist/dotfiles` transfer ownership to user to make editing easier
  ```sh
  sudo git clone https://github.com/KubqoA/dotfiles.git /persist/dotfiles
  sudo chown -R jakub /persist/dotfiles
  ```
9. Activate home-manager configuration
  ```sh
  cd /persist/dotfiles
  nix develop
  hm jakub-server switch
  ```
10. Reconnect to fully-apply new home-manager configuration
11. Make it possible to use `sops` to edit secrets
  ```sh
  mkdir -p ~/.config/sops/age
  nix-shell -p ssh-to-age --run "sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt"
  ```
12. Optional: Create a new SSH key, add it to GitHub, to make it easier to push changes directly from the server
  ```sh
  ssh-keygen -t ed25519
  cat ~/.ssh/id_ed25519.pub # add this to GitHub
  cd /persist/dotfiles
  git remote set-url origin git@github.com:KubqoA/dotfiles.git
  ```

