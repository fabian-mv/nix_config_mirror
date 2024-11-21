{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.apps.yubikey;
in {
  options.local.apps.yubikey = {
    enable = mkEnableOption "Yubikey home settings";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yubikey-manager
      yubico-pam
      yubikey-personalization
    ];
  };
}
