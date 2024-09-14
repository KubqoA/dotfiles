let
  organ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnWZPJ3Rll6Hxver8iH6TpM0EmNx75+zLuXENGT4fHG";
in {
  "jakub-organ-password-hash.age".publicKeys = [organ];
}
