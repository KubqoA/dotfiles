{lib, ...}: {
  defineSecrets = secrets:
    lib.genAttrs secrets (name: {
      file = ../secrets + "/${name}.age";
    });
}
