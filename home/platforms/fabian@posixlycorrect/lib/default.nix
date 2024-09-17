{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./steam
    ./terminal
  ];

  home.packages = with pkgs; [
    calc
    chromium
    darktable
    deluge
    discord
    file
    firefox
    gcc
    gperftools
    gwenview
    htop
    killall
    libreoffice-fresh
    lutris
    man-pages
    man-pages-posix
    mpv
    neovim
    obs-studio
    openrct2
    pavucontrol
    pdfarranger
    prismlauncher
    qpdfview
    runelite
    spotify
    tdesktop
    tree
    units
    unzip
    usbutils
    virt-manager
    vlc
    vpsfree-client
    vscodium-fhs
    yubikey-manager
    yubico-pam
    yubikey-personalization
    zip
    zola
    zoom-us
  ];
}
