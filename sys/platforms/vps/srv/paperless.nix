{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."docs.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:28981";
        };
      };
    };

    paperless = {
      enable = true;
      user = "paperless";
      passwordFile = "/var/trust/paperless/passwordFile";
      openMPThreadingWorkaround = true; # see https://github.com/NixOS/nixpkgs/issues/240591
      address = "127.0.0.1";
      port = 28981;
      settings = {
        PAPERLESS_URL = "docs.posixlycorrect.com";
        PAPERLESS_OCR_LANGUAGE = "eng+spa";
        PAPERLESS_APP_TITLE = "posixlycorrect";
        PAPERLESS_OCR_USER_ARGS = {
          "invalidate_digital_signatures" = true;
        };
      };
    };
  };
}
