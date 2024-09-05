{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  programs = {
    ## talvez esto debería moverse a base
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      initExtra = import ./zshrc.nix pkgs;
    };
    git = {
      enable = true;
      userEmail = "fabian@posixlycorrect.com";
      userName = "Fabian Montero";
      signing = {
        key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
        signByDefault = true;
      };
    };
    gpg = {
      enable = true;
      settings = {
        default-key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-emacs;
  };

  home.packages = with pkgs; [
    calc
    file
    gcc
    htop
    killall
    man-pages
    man-pages-posix
    neovim
    rar
    tree
    units
    unzip
    usbutils
    zip
  ];
}
