{...}: {
  moduleImports = let
    modulePath = path:
      if builtins.pathExists ../modules/${path}
      then ../modules/${path}
      else ../modules/${path}.nix;
  in
    builtins.map modulePath;
}
