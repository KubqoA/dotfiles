{lib, ...}: {
  defineSecrets = secretNames: secretsSet: let
    simpleSecrets = lib.genAttrs secretNames (name: {file = ../secrets + "/${name}.age";});
    complexSecrets = lib.mapAttrs (name: options: {file = ../secrets + "/${name}.age";} // options) secretsSet;
  in
    simpleSecrets // complexSecrets;
}
