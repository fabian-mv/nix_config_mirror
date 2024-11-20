{
  lib,
  pkgs,
  ...
}:
with lib; {
  users.groups = {
    mailsenders = {
      members = ["fabian" "mediawiki"];
    };
  };

  # esto sirve para que PHP pueda accesar la clave smtp de fastmail
  #systemd.services.phpfpm-mediawiki = {
  #  path = [ "/run/wrappers" ];
  #  serviceConfig.ReadWritePaths = [ "/run/wrappers" "/var/trust/fastmail" ];
  #};

  programs = {
    msmtp = {
      enable = true;
      accounts = {
        default = {
          auth = true;
          host = "smtp.fastmail.com";
          port = 587;
          passwordeval = "cat /var/trust/fastmail/smtp_key";
          user = "fabianmontero@fastmail.com";
          tls = true;
          tls_starttls = true;
        };
      };
    };
  };
}
