{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    impermanence.url = "github:nix-community/impermanence";
    hm-isolation.url = "github:3442/hm-isolation";
    nixGL.url = "github:guibou/nixGL";
    flake-utils.url = "github:numtide/flake-utils";
    vpsadminos.url = "github:vpsfreecz/vpsadminos";

    homepage.url = "git+https://git.posixlycorrect.com/fabian/homepage.git?ref=master";

    conduwuit = {
      url = "github:girlbossceo/conduwuit?ref=v0.4.5";
      #FIXME: Podrá volver a "nixpkgs" una vez que rocksdb.enableLiburing llegue a stable
      inputs.nixpkgs.follows = "unstable";
    };

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mediawikiSkinCitizen = {
      url = "github:StarCitizenTools/mediawiki-skins-Citizen/v2.27.0";
      flake = false;
    };
  };

  outputs = flakes @ {
    self,
    nixpkgs,
    unstable,
    home-manager,
    nur,
    impermanence,
    hm-isolation,
    nixGL,
    flake-utils,
    vpsadminos,
    homepage,
    conduwuit,
    mediawikiSkinCitizen,
    authentik-nix,
  }: let
    system = "x86_64-linux";

    importPkgs = flake:
      import flake {
        inherit system;

        config = import ./pkgs/config nixpkgs.lib;
        overlays = [nur.overlay self.overlays.default];
      };

    pkgs = importPkgs nixpkgs;

    inherit (pkgs.local.lib) importAll;

    local = import ./pkgs;
  in
    with pkgs.lib; {
      formatter.${system} = pkgs.alejandra;
      packages.${system} = pkgs.local;

      overlays.default = final: prev: let
        locals = local final prev;
      in
        locals.override
        // {
          local = locals;
          unstable = importPkgs unstable;
        };

      nixosConfigurations = let
        nixosSystem = {modules}:
          makeOverridable nixpkgs.lib.nixosSystem {
            inherit modules pkgs system;

            specialArgs = {
              inherit flakes;
            };
          };

        hostConfig = host:
          nixosSystem {
            modules = [
              ./sys
              host
            ];
          };
      in
        mapAttrs (_: hostConfig) (importAll {root = ./sys/platforms;});

      homeConfigurations = let
        registry = {...}: {
          config.nix.registry = mapAttrs (_:
            value {
              flake = value;
            })
          flakes;
        };

        home = platform:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./home
              platforms
              registry
              hm-isolation.homeManagerModule
            ];
          };

        platformHome = platform: let
          value = home platform;
        in {
          inherit value;
          name = "${value.config.home.username}@${value.config.local.hostname}";
        };
      in
        mapAttrs' (_: platformHome) (importAll {root = ./home/platforms;});
    };
}
