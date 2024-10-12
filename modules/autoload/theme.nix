{lib, ...}:
with lib; {
  options = {
    # To support dark/light mode switching
    theme.dark.onSwitch = mkOption {type = types.lines;};
    theme.light.onSwitch = mkOption {type = types.lines;};
  };
}
