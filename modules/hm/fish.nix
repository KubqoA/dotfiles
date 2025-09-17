{
  config,
  lib,
  pkgs,
  ...
}: {
  options = with lib; {
    programs.fish.art = mkOption {
      type = types.nullOr types.str;
      default = builtins.replaceStrings ["\\"] ["\\\\"] ''
                _    .  ,   .           .
            *  / \_ *  / \_      _  *        *   /\'__        *
              /    \  /    \,   ((        .    _/  /  \  *'.
         .   /\/\  /\/ :' __ \_  `          _^/  ^/    `--.
            /    \/  \  _/  \-'\      *    /.' ^_   \_   .'\  *
          /\  .-   `. \/     \ /==~=-=~=-=-;.  _/ \ -. `_/   \
         /  `-.__ ^   / .-'.--\ =-=~_=-=~=^/  _ `--./ .-'  `-
        /        `.  / /       `.~-^=-=~=^=.-'      '-._ `._
      '';
    };
  };

  config.programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fish-async-prompt";
        src = pkgs.fishPlugins.async-prompt;
      }
      {
        # Using a fork of hydro that shows username@hostname on SSH connections
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "thenktor";
          repo = "hydro";
          rev = "6714689d10b7173fe8d7afa9cba21d5839d31451";
          hash = "sha256-LknEQ1wMDRIJ8JcsPVK/LrJC0sgVWyR08pIEoNLnHPQ=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge;
      }
    ];
    functions = {
      fish_greeting = "echo $fish_greeting";
    };
    interactiveShellInit = let
      optionalGreeting =
        if builtins.isString config.programs.fish.art
        then ''"${config.programs.fish.art}"''
        else "";
    in ''
      set -U fish_greeting ${optionalGreeting}
      set -U fish_prompt_pwd_dir_length 10
      set -g hydro_symbol_start "\n"
      set -g hydro_symbol_prompt "❯"
      set -g hydro_symbol_git_dirty "*"
      set -g hydro_symbol_git_ahead "⇡"
      set -g hydro_symbol_git_behind "⇣"
      set -g hydro_color_pwd blue
      set -g hydro_color_git brblack
      set -g hydro_color_prompt magenta
      set -g hydro_color_duration yellow
      set -g hydro_multiline true
      set -g hydro_cmd_duration_threshold 10000
    '';
  };
}
