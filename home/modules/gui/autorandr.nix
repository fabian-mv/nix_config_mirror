{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.gui;
in {
  programs.autorandr = {
    profiles."default" = {
      fingerprint =
        mapAttrs
        (monitorId: monitor: monitor.fingerprint)
        cfg.monitors;

      config =
        mapAttrs (
          monitorId:
            filterAttrs
            (k: v:
              !elem k [
                #list of options to exclude from this list
                "fingerprint"
                "initialI3Workspace"
                "monitorId"
              ])
        )
        cfg.monitors;
    };
  };
}
