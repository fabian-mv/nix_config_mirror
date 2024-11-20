{
  lib,
  pkgs,
  flakes,
  ...
}:
with lib; {
  services = {
    nginx = {
      virtualHosts."wiki.posixlycorrect.com" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
      };
    };
    mediawiki = {
      enable = true;
      name = "posixlycorrect wiki";
      webserver = "nginx";
      nginx.hostName = "wiki.posixlycorrect.com";
      database.type = "postgres";

      passwordFile = "/run/keys/mediawiki-password";

      skins = {
        citizen = "${flakes.mediawikiSkinCitizen}";
      };

      extraConfig = ''
        # Disable anonymous editing and account creation
        $wgGroupPermissions['*']['edit'] = false;
        $wgGroupPermissions['*']['createaccount'] = false;

        $wgDefaultSkin = 'citizen';
        $wgDefaultMobileSkin = 'citizen';
        $wgCitizenThemeDefault = 'dark';
        $wgCitizenShowPageTools = 'login';
        $wgLogos = [
          'icon' => "https://posixlycorrect.com/favicon.png",
          '1x' => "https://posixlycorrect.com/favicon.png",
          '2x' => "https://posixlycorrect.com/favicon.png",
        ];

        $wgEnableEmail = false; #TODO: arreglar esto
        $wgNoReplyAddress = 'mediawiki@posixlycorrect.com';
        $wgEmergencyContact = 'mediawiki@posixlycorrect.com';
        $wgPasswordSender = 'mediawiki@posixlycorrect.com';
      '';

      extensions = {
        # some extensions are included and can enabled by passing null
        VisualEditor = null;
        CategoryTree = null;
        CiteThisPage = null;
        Scribunto = null;
        Cite = null;
        CodeEditor = null;
        Math = null;
        MultimediaViewer = null;
        PdfHandler = null;
        Poem = null;
        SecureLinkFixer = null;
        WikiEditor = null;
        ParserFunctions = null;

        TemplateStyles = pkgs.fetchzip {
          url = "https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/TemplateStyles/+archive/refs/heads/wmf/1.42.0-wmf.9.tar.gz";
          sha256 = "sha256-+EOwkDU8L0qQ4Wo3WDqNug4Pyz/PUhOiHKmNcFJO4G0=";
          stripRoot = false;
        };
      };
    };
  };
}
