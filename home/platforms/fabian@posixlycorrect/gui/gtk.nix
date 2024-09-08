#TODO: do i really need to take all these args?
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gruvbox-dark-icons-gtk
    libsForQt5.breeze-gtk
  ];
}
