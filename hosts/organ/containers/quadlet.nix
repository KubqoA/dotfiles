# Default config to enable quadlet support
{inputs, ...}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];
  environment.persistence."/persist".directories = ["/var/lib/containers"];
}
