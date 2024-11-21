{
  flakes,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps
    ./systemd
    ./gui
    ./isolation.nix
  ];

  local = {
    baseline.enable = true;
    apps = {
      terminal.enable = true;
      neovim.enable = true;
      steam.enable = true;
      yubikey.enable = true;
      browsers.enable = true;
    };
  };

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/fabian/nix";
    };

    "nixpkgs".flake = flakes.nixpkgs;
    "unstable".flake = flakes.unstable;
  };

  home = {
    stateVersion = "21.11"; # No tocar esto
    username = "fabian";
    homeDirectory = "/home/fabian";
    sessionVariables = {
      "EDITOR" = "nvim";
      "TERMINAL" = "kitty";
    };
    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };
  programs.home-manager.enable = true;
}
