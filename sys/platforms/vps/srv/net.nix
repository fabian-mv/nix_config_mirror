{
  lib,
  pkgs,
  ...
}:
with lib; {
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    domain = "posixlycorrect.com";
  };

  # ver https://nixos.org/manual/nixos/stable/index.html#module-security-acme-nginx
  security.acme = {
    acceptTerms = true;
    defaults.email = "fabian@posixlycorrect.com";
  };

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      logError = "/var/log/nginx/error.log";
      clientMaxBodySize = "99M";
      virtualHosts = {
        "posixlycorrect.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/".root = "${pkgs.local.homepage}";

            "~ ^/pki(?:/(.*))?$" = {
              # https://serverfault.com/a/476368
              alias = "${../pki}/$1";
              extraConfig = ''
                autoindex on;
                autoindex_exact_size on;
                autoindex_localtime on;
                autoindex_format html;
              '';
            };

            "~ ^/factorio_blueprints(?:/(.*))?$" = {
              # https://serverfault.com/a/476368
              alias = "${../cdn/factorio_blueprints}/$1";
              extraConfig = ''
                autoindex on;
                autoindex_exact_size on;
                autoindex_localtime on;
                autoindex_format html;
              '';
            };
          };
        };
      };
    };
    fail2ban = {
      enable = true;
      bantime = "10m";
      ignoreIP = ["37.205.12.34"]; # Never ban the server's own IP
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "48h"; # Do not ban for more than 48h
        rndtime = "10m";
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = {
        # https://discourse.nixos.org/t/fail2ban-with-nginx-and-authelia/31419
        nginx-botsearch.settings = {
          # Usar log en vez de journalctl
          # TODO: Pasar todo a systemd?
          backend = "pyinotify";
          logpath = "/var/log/nginx/*.log";
          journalmatch = "";
        };
        nginx-bad-request.settings = {
          backend = "pyinotify";
          logpath = "/var/log/nginx/*.log";
          journalmatch = "";
          maxretry = 10;
        };
      };
    };
  };
}
