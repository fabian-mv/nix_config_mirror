{
  config,
  lib,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."vault.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };

    #fail2ban.jails.gitea.settings = { };

    postgresql = {
      ensureDatabases = ["vaultwarden"];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
    };

    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      environmentFile = "/var/trust/vaultwarden/smtp_key";
      config = {
        DOMAIN = "https://vault.posixlycorrect.com";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        ROCKET_LOG = "critical";

        # Using FASTMAIL mail server
        # If you use an external mail server, follow:
        #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        SMTP_HOST = "smtp.fastmail.com";
        SMTP_PORT = 587;
        SMTP_SECURITY = "starttls";

        SMTP_FROM = "vault@posixlycorrect.com";
        SMTP_FROM_NAME = "posixlycorrect vaultwarden server";

        SMTP_AUTH_MECHANISM = "PLAIN";

        DATABASE_URL = "postgresql:///vaultwarden";
      };
    };

    bitwarden-directory-connector-cli.domain = "https://vault.posixlycorrect.com";
  };
}
