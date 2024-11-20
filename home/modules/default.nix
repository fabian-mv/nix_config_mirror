{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./terminal
    ./neovim.nix
  ];
}
