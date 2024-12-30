# To support dark/light mode switching
{lib, ...}:
with lib; {
  options = {
    theme.dark.onSwitch = mkOption {
      type = types.lines;
      default = "";
      description = "Commands to run when the OS theme switches to dark mode";
    };
    theme.light.onSwitch = mkOption {
      type = types.lines;
      default = "";
      description = "Commands to run when the OS theme switches to light mode";
    };
  };
}
