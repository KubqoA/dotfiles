let
  organ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINabVZEpYBGh7+GROUkysSw0vNNUJGi2umVRwPgXNrCQ";
in {
  "organ-jakub-password-hash.age".publicKeys = [organ];
  # "organ-sasl-passwd.age".publicKeys = [organ];
  "organ-tailscale-auth-key.age".publicKeys = [organ];
  # "organ-git-ssh-key.age".publicKeys = [organ];
}
