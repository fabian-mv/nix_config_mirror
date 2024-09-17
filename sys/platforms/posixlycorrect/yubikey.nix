{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  environment.etc."pkcs11/modules/ykcs11".text = ''
    module: ${pkgs.yubico-piv-tool}/lib/libykcs11.so
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
    id = ["27677315"];
  };
}
