{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."stream.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
        locations."/" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };

    jellyfin = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin";
      dataDir = "/mnt/export2008/jellyfin/dataDir";
      cacheDir = "/mnt/export2008/jellyfin/cacheDir";
    };
  };
}
