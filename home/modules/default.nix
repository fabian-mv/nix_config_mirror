{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./terminal
    ./neovim.nix
    ./baseline.nix
  ];
}
