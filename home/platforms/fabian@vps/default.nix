{
  config,
  pkgs,
  lib,
  flakes,
  ...
}:
with lib; {
  imports = [
    ./cli.nix
  ];

  home = {
    stateVersion = "24.05"; # No tocar esto
    username = "fabian";
    homeDirectory = "/home/fabian";
    sessionVariables = {
      "EDITOR" = "nvim";
    };
  };

  xdg.enable = true;

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/fabian/nix";
    };

    "nixpkgs".flake = flakes.nixpkgs;
    "unstable".flake = flakes.unstable;
  };
}
