{pkgs, ...}: {
  programs.fish = let
    art = builtins.replaceStrings ["\\"] ["\\\\"] ''
              _    .  ,   .           .
          *  / \_ *  / \_      _  *        *   /\'__        *
            /    \  /    \,   ((        .    _/  /  \  *'.
       .   /\/\  /\/ :' __ \_  `          _^/  ^/    `--.
          /    \/  \  _/  \-'\      *    /.' ^_   \_   .'\  *
        /\  .-   `. \/     \ /==~=-=~=-=-;.  _/ \ -. `_/   \
       /  `-.__ ^   / .-'.--\ =-=~_=-=~=^/  _ `--./ .-'  `-
      /        `.  / /       `.~-^=-=~=^=.-'      '-._ `._
    '';
  in {
    enable = true;
    plugins = [
      {
        name = "fish-async-prompt";
        src = pkgs.fishPlugins.async-prompt;
      }
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "75ab7168a35358b3d08eeefad4ff0dd306bd80d4";
          hash = "sha256-QYq4sU41/iKvDUczWLYRGqDQpVASF/+6brJJ8IxypjE=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge;
      }
    ];
    interactiveShellInit = ''
      set --global hydro_symbol_start "\n"
      set --global hydro_symbol_prompt "❯"
      set --global hydro_symbol_git_dirty "*"
      set --global hydro_symbol_git_ahead "⇡"
      set --global hydro_symbol_git_behind "⇣"
      set --global hydro_color_pwd blue
      set --global hydro_color_git brblack
      set --global hydro_color_prompt magenta
      set --global hydro_color_duration yellow
      set --global hydro_multiline true
      set --global hydro_cmd_duration_threshold 10000
      set -g fish_greeting "${art}"
    '';
  };

  programs.ghostty.enableFishIntegration = true;
  programs.mise.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;
}
