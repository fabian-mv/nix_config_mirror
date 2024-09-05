{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "pycharm-professional"
      "rar"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
      "steam-run"
      "teams"
      "vscode-extension-ms-vscode-cpptools"
      "vmware-horizon-client"
      "zoom"
    ];
}
