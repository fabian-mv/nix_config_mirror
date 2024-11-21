{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
  ];

  home.packages = with pkgs; [
    calibre
    darktable
    deluge
    discord
    gcc
    gwenview
    kdenlive
    libreoffice-fresh
    lutris
    mpv
    obs-studio
    openrct2
    pavucontrol
    pdfarranger
    prismlauncher
    qpdfview
    runelite
    spotify
    tdesktop
    usbutils
    virt-manager
    vpsfree-client
    vscodium-fhs
    zola
    zoom-us
  ];
}
