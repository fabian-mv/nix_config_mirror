{
  lib,
  pkgs,
  flakes,
  ...
}:
with lib; {
  imports = [flakes.authentik-nix.nixosModules.default];

  options = {
    services.nginx.virtualHosts = mkOption {
      type = with lib.types;
        attrsOf (
          submodule
          (
            {config, ...}: {
              options = {
                enableAuthentik = mkOption {
                  default = false;
                  type = bool;
                };
                locations = mkOption {
                  type = attrsOf (
                    submodule {
                      config = mkIf config.enableAuthentik {
                        extraConfig = ''
                          auth_request        /outpost.goauthentik.io/auth/nginx;
                          error_page          401 = @goauthentik_proxy_signin;
                          auth_request_set $auth_cookie $upstream_http_set_cookie;
                          add_header Set-Cookie $auth_cookie;

                          # translate headers from the outposts back to the actual upstream
                          auth_request_set $authentik_username $upstream_http_x_authentik_username;
                          auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
                          auth_request_set $authentik_email $upstream_http_x_authentik_email;
                          auth_request_set $authentik_name $upstream_http_x_authentik_name;
                          auth_request_set $authentik_uid $upstream_http_x_authentik_uid;

                          proxy_set_header X-authentik-username $authentik_username;
                          proxy_set_header X-authentik-groups $authentik_groups;
                          proxy_set_header X-authentik-email $authentik_email;
                          proxy_set_header X-authentik-name $authentik_name;
                          proxy_set_header X-authentik-uid $authentik_uid;
                        '';
                      };
                    }
                  );
                };
              };
              config = mkIf config.enableAuthentik {
                extraConfig = ''
                  proxy_buffers 8 16k;
                  proxy_buffer_size 32k;

                  location /outpost.goauthentik.io {
                    proxy_pass          http://localhost:9000/outpost.goauthentik.io;
                    # ensure the host of this vserver matches your external URL you've configured
                    # in authentik
                    proxy_set_header    Host $host;
                    proxy_redirect      http://localhost:9000 https://auth.posixlycorrect.com;
                    proxy_set_header    X-Original-URL $scheme://$http_host$request_uri;
                    add_header          Set-Cookie $auth_cookie;
                    auth_request_set    $auth_cookie $upstream_http_set_cookie;

                    # required for POST requests to work
                    proxy_pass_request_body off;
                    proxy_set_header Content-Length "";
                  }

                  location @goauthentik_proxy_signin {
                    internal;
                    add_header Set-Cookie $auth_cookie;
                    return 302 /outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
                    # For domain level, use the below error_page to redirect to your authentik server with the full redirect path
                    # return 302 https://authentik.company/outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
                  }
                '';
              };
            }
          )
        );
    };
  };

  config = {
    services = {
      authentik = {
        enable = true;
        environmentFile = "/var/trust/authentik/authentik-env";
        nginx = {
          enable = true;
          enableACME = true;
          host = "auth.posixlycorrect.com";
        };
        settings = {
          email = {
            host = "smtp.fastmail.com";
            port = 587;
            username = "fabianmontero@fastmail.com";
            use_tls = true;
            use_ssl = false;
            from = "auth@posixlycorrect.com";
          };
          disable_startup_analytics = true;
          avatars = "initials";
        };
      };
    };
  };
}
