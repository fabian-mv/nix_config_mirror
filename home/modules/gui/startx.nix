{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.local.gui.enable {
    home.file.".xinitrc".source = let
      content = ''
        exec ~/.xsession
      '';
    in
      pkgs.writeShellScript "xinitrc" content;
  };
}
