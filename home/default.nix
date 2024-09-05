{
  self,
  nixpkgs,
  unstable,
  hm-isolation,
  nixGL,
}: {
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    (hm-isolation.homeManagerModule)
    ./accounts.nix
    ./apps
    ./allowUnfreeWhitelist.nix
    ./gui
    ./isolation.nix
    ./options.nix
    ./cli.nix
    ./systemd
  ];

  nixpkgs.overlays = [self.overlay nixGL.overlay];

  services.ssh-agent.enable = true;

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

  xdg.enable = true;

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/fabian/nix";
    };

    "nixpkgs".flake = nixpkgs;
    "unstable".flake = unstable;
  };

  programs.home-manager.enable = true;

  local = {
    apps.enable = mkDefault (!config.home.isolation.active);

    gui = {
      enable = mkDefault true;
      desktop = mkDefault (!config.home.isolation.active);
    };
  };
}
