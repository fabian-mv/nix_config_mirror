#TODO: keys will not be shared in all platforms
{
  flakes,
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  xdg.enable = true;

  programs = {
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
}
