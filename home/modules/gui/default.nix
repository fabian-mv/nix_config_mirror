{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.local.gui;
  monitorType = {setName}: (
    types.submodule ({name ? null, ...}: {
      options = {
        monitorId = mkOption {
          type = types.str;
          example = "DP-1";
          readOnly = true;
          internal = true;
        };
        primary = mkOption {
          type = types.bool;
          default = false;
          description = "is primary monitor";
          example = "true";
        };
        position = mkOption {
          type = types.str;
          example = "0x0";
        };
        mode = mkOption {
          type = types.str;
          description = "resolution";
          default = "1920x1080";
          example = "1920x1080";
        };
        rate = mkOption {
          type = types.str;
          description = "refresh rate";
          example = "143.85";
        };
        rotate = mkOption {
          type = types.str;
          default = "normal";
          example = "left";
        };
        fingerprint = mkOption {
          type = types.str;
          example = "00ffffffffffff003669a03bd4040000231e0104a5341d783bd005ac5048a627125054bfcf00814081809500714f81c0b30001010101023a801871382d40582c450009252100001e0882805070384d400820f80c09252100001a000000fd003090b4b422010a202020202020000000fc004d53492047323443340a20202001a2020320f14d010304131f120211900e0f1d1e230907078301000065030c001000866f80a0703840403020350009252100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e9";
        };
        initialI3Workspace = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 1;
        };
      };
      config = optionalAttrs setName {
        # make this better later
        monitorId = name;
      };
    })
  );
in {
  options.local.gui = {
    enable = mkEnableOption "GUI settings";
    primaryMonitor = mkOption {
      type = monitorType {setName = false;};
      readOnly = true;
      internal = true;
    };
    monitors = mkOption {
      type = types.attrsOf (monitorType {setName = true;});
    };
    displayBatteryLevel = mkOption {
      type = types.bool;
      default = false;
      description = "show battery level on polybar";
      example = "true";
    };
  };

  imports = [
    ./autorandr.nix
    ./fonts.nix
    ./i3.nix
    ./polybar.nix
    ./startx.nix # move to ly once 24.11 comes out :(
    ./picom.nix
  ];

  config = let
    primaryMonitors =
      filter (monitor: monitor.primary)
      (attrValues cfg.monitors);
  in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = length primaryMonitors == 1;
          message = "Exactly one (1) primary monitor is requiered.";
        }
      ];

      local.gui.primaryMonitor = head primaryMonitors;

      xsession = {
        enable = true;
        windowManager.i3.enable = true;
      };

      programs.autorandr.enable = true;
      services = {
        dunst.enable = true;
        betterlockscreen.enable = true;
        polybar.enable = true;
        picom.enable = true;
      };
    };
}
