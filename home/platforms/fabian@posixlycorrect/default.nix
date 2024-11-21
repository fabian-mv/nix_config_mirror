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

  local.baseline.enable = true;
  local.apps.terminal.enable = true;
  local.apps.neovim.enable = true;

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
