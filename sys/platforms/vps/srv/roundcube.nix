{
  lib,
  pkgs,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."mail.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
      };
    };

    roundcube = {
      enable = true;
      hostName = "mail.posixlycorrect.com";
      configureNginx = true;
      maxAttachmentSize = 2048; #MB
      plugins = [
        "archive"
        "attachment_reminder"
        "carddav"
        "contextmenu"
        "custom_from"
        "emoticons"
        "enigma"
        "hide_blockquote"
        "managesieve"
        "markasjunk"
        "newmail_notifier"
        "password"
        "persistent_login"
        "reconnect"
        "show_additional_headers"
        "userinfo"
        "vcard_attachments"
        "zipdownload"
      ];

      dicts = with pkgs.aspellDicts; [
        es
        en
      ];
    };
  };
}
