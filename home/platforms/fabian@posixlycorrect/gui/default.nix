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
  ];

  services = {
    picom.enable = true;
    dunst.enable = true;
    betterlockscreen.enable = true;
  };
}
