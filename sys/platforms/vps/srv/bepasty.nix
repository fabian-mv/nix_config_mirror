{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."send.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
        };
      };
    };

    bepasty = {
      enable = true;
      servers = {
        "send" = {
          bind = "127.0.0.1:8989";
          secretKeyFile = "/var/trust/bepasty/secretKeyFile";
          dataDir = "/mnt/export2011/data";
          defaultPermissions = "read,create,delete";
          extraConfig = ''
            SITENAME = 'send.posixlycorrect.com'
            MAX_ALLOWED_FILE_SIZE = 4 * 1000 * 1000 * 1000
            SESSION_COOKIE_SECURE = True
            ASCIINEMA_THEME = 'asciinema'
          '';
        };
      };
    };
  };
}
