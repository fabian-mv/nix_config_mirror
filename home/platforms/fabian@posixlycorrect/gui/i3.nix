{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = let
      mod = "Mod4";
    in {
      modifier = mod;

      fonts = {
        names = ["JetBrains Mono"];
        style = "Regular";
        size = 8.0;
      };

      gaps = {
        inner = 10;
        outer = -10;
      };

      window = {
        hideEdgeBorders = "both";
      };

      colors = {
        focused = {
          background = "#222222";
          border = "#4c7899";
          childBorder = "#222222";
          indicator = "#292d2e";
          text = "#888888";
        };
      };

      # mkOptionDefault hace que se ponga la config por default
      # y se sobreescriba las cosas que pongo acá
      # NO QUITARLO. ver man home-configuration.nix
      keybindings = mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty ${pkgs.tmux}/bin/tmux";
        "${mod}+Tab" = "focus right";
        "${mod}+Shift+Tab" = "focus left";
        "${mod}+Shift+s" = "exec ${pkgs.maim}/bin/maim -s -u | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i";
        "${mod}+Shift+w" = "move workspace to output right";
        "${mod}+l" = "exec ${pkgs.betterlockscreen}/bin/betterlockscreen -l";
      };

      startup = [
        {
          command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pkgs.i3lock}/bin/i3lock --nofork";
          notification = false;
        }
        {
          command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          notification = false;
        }
        # sería nice hostear esta imagen en el server y fetchearla si no existe
        {
          command = "${pkgs.feh}/bin/feh --bg-fill ${config.home.homeDirectory}/Pictures/wallpapers/jupiter.png";
          notification = false;
          always = true;
        }
        {
          command = "${pkgs.i3-gaps}/bin/i3-msg 'workspace 1; exec ${pkgs.firefox}/bin/firefox'";
        }
        {
          command = "${pkgs.i3-gaps}/bin/i3-msg 'workspace 2; exec ${pkgs.tdesktop}/bin/telegram-desktop'";
        }
        #{
        #  command = "${pkgs.i3-gaps}/bin/i3-msg 'workspace 2; exec ${pkgs.element-desktop}/bin/element-desktop'";
        #}
        {
          command = "${pkgs.systemd}/bin/systemctl --user restart polybar.service";
          notification = false;
          always = true;
        }
        {
          command = "${pkgs.autorandr}/bin/autorandr -c";
          notification = false;
          always = true;
        }
      ];

      workspaceOutputAssign = [
        {
          output = "DP-1";
          workspace = "1";
        }
        {
          output = "DP-2";
          workspace = "10";
        }
      ];

      bars = [];
    };
  };
}
