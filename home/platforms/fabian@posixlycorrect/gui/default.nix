{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./autorandr.nix
    ./fonts.nix
    ./i3.nix
    ./polybar.nix
    ./startx.nix
    ./picom.nix
  ];

  services = {
    dunst.enable = true;
    betterlockscreen.enable = true;
  };
}
