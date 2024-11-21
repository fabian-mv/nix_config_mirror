{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.baseline;
in {
  options.local.baseline = {
    enable = mkEnableOption "Basic settings";
  };
  config = mkIf cfg.enable {
    xdg.enable = true;

    home.packages = with pkgs; [
      calc
      file
      git
      htop
      killall
      man-pages
      man-pages-posix
      tree
      units
      unzip
      zip
    ];
  };
}
