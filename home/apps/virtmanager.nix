{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.apps.virtmanager;
in {
  options.local.apps.virtmanager.enable = mkEnableOption "Virtmanager";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
