{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."firefly.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
      };
    };

    firefly-iii = {
      enable = true;
      user = "firefly-iii";
      dataDir = "/var/lib/firefly-iii";
      enableNginx = true;
      virtualHost = "firefly.posixlycorrect.com";
      settings = {
        SITE_OWNER = "fabian@posixlycorrect.com";
        DB_CONNECTION = "sqlite";
        APP_ENV = "local";
        APP_KEY_FILE = "/var/trust/firefly/key_file";
      };
    };
  };
}
