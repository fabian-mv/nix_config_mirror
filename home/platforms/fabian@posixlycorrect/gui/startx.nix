{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  xsession.enable = true;

  home.file.".xinitrc".source = let
    content = ''
      exec ~/.xsession
    '';
  in
    pkgs.writeShellScript "xinitrc" content;
}
