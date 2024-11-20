{
  lib,
  pkgs,
  config,
  flakes,
  ...
}:
with lib; let
  subdomain = "matrix.posixlycorrect.com";
  baseUrl = "https://${subdomain}";
in {
  # ver https://nixos.org/manual/nixos/stable/#module-services-matrix
  services = {
    matrix-conduit = {
      enable = true;
      package = flakes.conduwuit.packages.${pkgs.system}.default;
      settings.global = {
        address = "::1";
        port = 6167;
        allow_encryption = true;
        allow_federation = true;
        allow_registration = false;
        database_backend = "rocksdb";
        server_name = "posixlycorrect.com";
        allow_check_for_updates = true;
        new_user_displayname_suffix = "";
      };
    };

    nginx.virtualHosts = let
      clientConfig."m.homeserver".base_url = baseUrl;
      serverConfig."m.server" = "${subdomain}:443";
      mkWellKnown = data: ''
        default_type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '${builtins.toJSON data}';
      '';
    in {
      "posixlycorrect.com" = {
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${subdomain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_headers_hash_max_size 512;
          proxy_headers_hash_bucket_size 128;
        '';
        locations."/".extraConfig = ''
          return 403;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:6167";
        locations."/_synapse/client".proxyPass = "http://[::1]:6167";
      };
    };
  };
}
