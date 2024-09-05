{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (!config.home.isolation.active) {
    accounts.email.maildirBasePath = "${config.home.homeDirectory}/mail";
    accounts.email.accounts = {
      "default" = {
        address = "fabian@posixlycorrect.com";
        userName = "fabianmontero@fastmail.com";
        realName = "fabian";
        primary = true;
        flavor = "fastmail.com";

        smtp = {
          host = "smtp.fastmail.com";
          port = 465;
        };
        imap = {
          host = "imap.fastmail.com";
          port = 993;
          tls.enable = true;
        };

        passwordCommand = "gpg -d ${config.home.homeDirectory}/secrets/fastmail.password.gpg 2> /dev/null";

        gpg = {
          encryptByDefault = true;
          signByDefault = true;
          key = "7AA277E604A4173916BBB4E91FFAC35E1798174F";
        };

        thunderbird = {
          enable = true;
          settings = id: {
            "mail.openpgp.allow_external_gnupg" = true;
          };
        };
        neomutt = {
          enable = true;
        };

        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          remove = "both";
        };
      };
    };

    programs = {
      mbsync.enable = true;
      thunderbird = {
        enable = true;
        profiles = {
          "default" = {
            isDefault = true;
          };
        };
      };
      neomutt = {
        enable = true;
        sort = "date-received";
        vimKeys = true;
        sidebar = {
          enable = true;
        };
        #settings = {
        #  maildir_check_cur = "yes";
        #};
        extraConfig = ''
          mailboxes `find ~/mail/ -type d -name cur -printf '%h '`
          timeout-hook 'echo `mbsync -a`'
          startup-hook 'echo `mbsync -a`'
        '';
      };
    };
  };
}
