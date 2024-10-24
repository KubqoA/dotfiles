![Organ](./organ.jpg)

<sub><sup>Photo by <a href="https://unsplash.com/@haozlife?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Hao Zhang</a> on <a href="https://unsplash.com/photos/man-playing-brown-musical-instrument-dFpDCSECapg?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a></sup></sub>

# organ
ARM-based server running on Hetzner cloud

## Setup
1. Create a new server on Hetzner Cloud
  - Tested with Ubuntu 24.04
  - Arm64 architecture
  - Assign an IPv4 and IPv6 address
  - Add your SSH key
2. Get the SSH keys from the server
  ```sh
  ssh-keyscan <server-ip>
  ```
3. Update the [`secrets.nix`](../../secrets/secrets.nix) file with the SSH key, and re-key all the relevant secrets
4. Update [`networking.nix`](./networking.nix) with the correct IP addresses
5. Run the following command from the root of the repository
  ```sh
  ./hosts/organ/install.sh
  ```

And that's it!
