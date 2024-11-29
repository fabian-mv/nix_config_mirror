{
  flakes,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps.nix
    ./systemd
    ./isolation.nix
  ];

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/fabian/nix";
    };

    "nixpkgs".flake = flakes.nixpkgs;
    "unstable".flake = flakes.unstable;
  };

  local.gui = {
    enable = true;
    #? wallpaperPath = ""; place wallpaper in config?
    monitors = {
      DP-1 = {
        primary = true;
        position = "0x0";
        mode = "1920x1080";
        rate = "143.85";
        fingerprint = "00ffffffffffff003669a03bd4040000231e0104a5341d783bd005ac5048a627125054bfcf00814081809500714f81c0b30001010101023a801871382d40582c450009252100001e0882805070384d400820f80c09252100001a000000fd003090b4b422010a202020202020000000fc004d53492047323443340a20202001a2020320f14d010304131f120211900e0f1d1e230907078301000065030c001000866f80a0703840403020350009252100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e9";
        initialI3Workspace = 1;
      };
      DP-2 = {
        position = "1920x0";
        mode = "1920x1080";
        rate = "59.94";
        fingerprint = "00ffffffffffff0009d1e77845540000061f0104a5351e783a0565a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c45000f282100001e000000ff0039324d30303033323031510a20000000fd00324c1e5311010a202020202020000000fc0042656e51204757323438300a20019b02031cf14f901f041303120211011406071516052309070783010000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009f011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000000000000000008d";
        initialI3Workspace = 10;
      };
    };
  };

  home = {
    stateVersion = "21.11"; # No tocar esto
    username = "fabian";
    homeDirectory = "/home/fabian";
    sessionVariables = {
      "EDITOR" = "nvim";
      "TERMINAL" = "kitty";
    };
    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };
  programs.home-manager.enable = true;
}
