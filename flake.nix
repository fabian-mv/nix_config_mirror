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
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    nur,
    hm-isolation,
    nixGL,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

    inherit (pkgs) lib;

    base = platform: {
      name = platform;
      value = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [(import ./base)];
      };
    };

    home = platform: {
      name = "fabian@${platform}";
      value = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          (import ./home {
            inherit self nixpkgs unstable hm-isolation nixGL;
          })

          ./home/platforms/${platform}.nix

          {
            config.local = {inherit platform;};
          }
        ];
      };
    };

    localPkgs = import ./pkgs;

    platforms = domain:
      map
      (lib.removeSuffix ".nix")
      (lib.attrNames (builtins.readDir ./${domain}/platforms));

    configs = domain: builder:
      lib.listToAttrs
      (map builder (platforms domain));
  in {
    nixosConfigurations = configs "base" base;
    homeConfigurations = configs "home" home;
    packages.${system} = localPkgs pkgs;
    formatter.${system} = pkgs.alejandra;

    overlay = self: super: {
      unstable = import unstable {
        inherit (super) config system;
      };
      local = localPkgs self;
    };
  };
}
