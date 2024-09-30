{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  home.packages = [
    (pkgs.callPackage ./package.nix {})
    pkgs.protonup
    pkgs.winetricks
    pkgs.protontricks
  ];
}
