{
  lib,
  pkgs,
  ...
}:
with lib; {
  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
    };
    git = {
      enable = true;
      userEmail = "fabian@posixlycorrect.com";
      userName = "fabian";
    };
    neovim.enable = true;
  };
  home.packages = with pkgs; [
    file
    htop
    killall
    man-pages
    man-pages-posix
    tree
    zip
    unzip
  ];
}
