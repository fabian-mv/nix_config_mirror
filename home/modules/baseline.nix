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
  };
}
