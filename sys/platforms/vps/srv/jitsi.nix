{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."meet.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
      };
    };

    jitsi-meet = {
      enable = true;
      hostName = "meet.posixlycorrect.com";
      nginx.enable = true;
      config = {
        enableWelcomePage = true;
        prejoinPageEnabled = true;
        defaultLang = "en";
      };
      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
  };
}
