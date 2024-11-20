{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."notes.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
      };
    };

    trilium-server = {
      enable = true;
      host = "127.0.0.1";
      port = 8458;
      noAuthentication = false;
      instanceName = "posixlycorrect";
      dataDir = "/var/lib/trilium";
      nginx = {
        enable = true;
        hostName = "notes.posixlycorrect.com";
      };
    };
  };
}
