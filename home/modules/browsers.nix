{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.apps.browsers;
in {
  options.local.apps.browsers = {
    enable = mkEnableOption "Browser home settings";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      firefox
    ];
  };
}
