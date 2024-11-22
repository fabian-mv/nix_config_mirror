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
      package = pkgs.roundcube.withPlugins (plugins: [
        #plugins.carddav
        plugins.contextmenu
        plugins.custom_from
        plugins.persistent_login
      ]);
      plugins = [
        "archive"
        "attachment_reminder"
        #"carddav"
        "contextmenu"
        "custom_from"
        "emoticons"
        #"enigma"
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
      extraConfig = ''
        $config['smtp_host'] = "ssl://smtp.fastmail.com:465";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
        $config['imap_host'] = "ssl://imap.fastmail.com:993";
      '';
    };
  };
}
