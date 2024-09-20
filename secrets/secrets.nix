let
  organ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnWZPJ3Rll6Hxver8iH6TpM0EmNx75+zLuXENGT4fHG";
in {
  "organ-jakub-password-hash.age".publicKeys = [organ];
  "organ-jakubarbetme-tsig.age".publicKeys = [organ];
  "organ-sasl-passwd.age".publicKeys = [organ];
  "organ-tailscale-auth-key.age".publicKeys = [organ];
  "organ-git-ssh-key.age".publicKeys = [organ];
}
