{
  config,
  pkgs,
  lib,
  flakes,
  ...
}:
with lib; {
  imports = [
    ./net.nix
    ./mediawiki.nix
    # ./jitsi.nix
    # ./matrix.nix currently not being used
    ./forgejo.nix
    ./vaultwarden.nix
    # ./bepasty.nix
    # ./jellyfin.nix
    ./msmtp.nix
    ./kuma.nix
    # ./authentik.nix  consumes too much RAM and serves no purpose for now
    ./paperless.nix
    ./trilium.nix
    ./firefly.nix
  ];
}
