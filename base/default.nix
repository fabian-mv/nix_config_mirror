# Edet this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration-custom.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "posixlycorrect"; # Define your hostname. !!mover esto a platform
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Costa_Rica";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.startx.enable = true;
  };
  services.libinput.enable = true;

  hardware.opengl.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

  users = {
    users.fabian = {
      isNormalUser = true;
      uid = 1002; # nunca cambiar mi ID de usuario
      group = "fabian";
      shell = pkgs.zsh;
      extraGroups = ["users" "wheel" "networkmanager" "dialout" "libvirtd"];
    };
    groups.fabian.gid = 1002;
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  users.users.temp = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages = [pkgs.OVMFFull.fd];
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  # boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  # boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "vfio-pci.ids=1002:699f,1002:aae0" "video=efifb:off" ];
  virtualisation.libvirtd.onBoot = "start";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };

  hardware.opengl.driSupport32Bit = true;

  services.openssh.enable = true;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  system.stateVersion = "21.11"; # No tocar esto
}
