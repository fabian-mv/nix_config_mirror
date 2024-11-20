{
  config,
  pkgs,
  lib,
  flakes,
  ...
}:
with lib; {
  imports = [
    flakes.vpsadminos.nixosConfigurations.container
    flakes.home-manager.nixosModules.home-manager
    flakes.impermanence.nixosModule
    ./srv
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {inherit flakes;};

    users.fabian = {
      imports = [
        flakes.impermanence.nixosModules.home-manager.impermanence
        "${flakes.self}/home/platforms/fabian@vps"
        "${flakes.self}/home"
      ];
    };
  };

  programs = {
    zsh.enable = true;
    fuse.userAllowOther = true;
  };

  networking.hostName = "vps";

  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';

    # No me interesa el global registry
    settings.flake-registry = "";
  };

  users = {
    users.fabian = {
      isNormalUser = true;
      uid = 1000;
      group = "fabian";
      shell = pkgs.zsh;
      extraGroups = ["users" "wheel" "networkmanager" "dialout" "libvirtd"];
      openssh.authorizedKeys.keyFiles = [pki/fabian.ssh];
    };
    groups.fabian.gid = 1000;
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  security.dhparams = {
    enable = true;
    defaultBitSize = 4096;
  };

  fileSystems = {
    "/mnt/export2008" = {
      device = "172.16.129.19:/nas/5876";
      fsType = "nfs";
      options = ["nofail" "noatime"];
    };

    "/mnt/export2011" = {
      device = "172.16.129.151:/nas/5876/bepasty";
      fsType = "nfs";
      options = ["nofail" "noatime" "noexec"];
    };
  };

  services.earlyoom = {
    enable = mkDefault true;
    enableNotifications = true;
  };

  # Coredumps son un riesgo de seguridad y puden usar mucho disco
  systemd.coredump.extraConfig = ''
    Storage=none
    ProcessSizeMax=0
  '';

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "24.05";
}
