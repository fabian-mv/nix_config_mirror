{
  config,
  lib,
  ...
}:
with lib; {
  config = {
    environment.etc."fail2ban/filter.d/gitea.local".text = ''
      [Definition]
      failregex = .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
      ignoreregex =
    '';

    services = {
      nginx = {
        virtualHosts."git.posixlycorrect.com" = {
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
          locations."/".proxyPass = "http://localhost:9170";
        };
      };

      fail2ban.jails.gitea.settings = {
        filter = "gitea";
        logpath = "${config.services.gitea.stateDir}/log/gitea.log";
        maxretry = "10";
        findtime = "3600";
        bantime = "900";
        action = "iptables-allports";
      };

      forgejo = {
        enable = true;
        lfs.enable = true;
        useWizard = false;
        settings = {
          general.APP_NAME = "posixlycorrect";
          ui.DEFAULT_THEME = "forgejo-dark";
          server = {
            DOMAIN = "git.posixlycorrect.com";
            ROOT_URL = "https://git.posixlycorrect.com";
            HTTP_PORT = 9170;
            LANDING_PAGE = "explore";
          };

          # You can temporarily allow registration to create an admin user.
          service.DISABLE_REGISTRATION = true;

          # ver https://github.com/nektos/act
          actions = {
            ENABLED = false;
          };
          mailer = {
            ENABLED = false;
          };
        };
      };
    };
  };
}
