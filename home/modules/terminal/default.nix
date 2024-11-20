{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.apps.terminal;
in {
  options.local.apps.terminal.enable = mkEnableOption "Terminal emulator settings";
  config = mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        extraConfig = import ./kitty.conf.nix;
      };

      tmux = {
        enable = true;
        aggressiveResize = true;
        clock24 = true;
        escapeTime = 10;
        terminal = "xterm-256color";
        keyMode = "emacs";

        extraConfig = ''
          set -g mouse on
          set -ga update-environment " LIFT_PID"
          set -g set-titles on
          set -g renumber-windows on
          set -sa terminal-overrides ',xterm-termite:RGB'
          set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,} %H:%M %d-%b-%y"
        '';
      };
    };

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      initExtra = import ./zshrc.nix pkgs;
    };

    programs.git = {
      enable = true;
      userEmail = "fabian@posixlycorrect.com";
      userName = "Fabian Montero";
      #signing = {
      #  key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
      #  signByDefault = true;
      #};
    };

    programs.gpg = {
      enable = true;
      #settings = {
      #  default-key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
      #};
    };

    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryPackage = pkgs.pinentry-emacs;
    };

    accounts.email.accounts = {
      "fabian@posixlycorrect.com" = {
        address = "fabian@posixlycorrect.com";
        userName = "fabianmontero@fastmail.com";
        realName = "fabian";
        primary = true;
        flavor = "fastmail.com";

        gpg = {
          encryptByDefault = true;
          signByDefault = true;
          key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
        };
      };
    };
  };
}
