{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  subvol = subvol: {
    device = "/dev/disk/by-uuid/645fdba0-5c03-4285-926b-facded1ee259";
    fsType = "btrfs";
    options = ["subvol=${subvol}" "compress=zstd" "noatime" "ssd"];
  };
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd = {
    availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    luks.devices."toplevel" = {
      device = "/dev/disk/by-uuid/58277baa-90d4-4a5e-a658-1b918b89130a";
      preLVM = false;
    };
  };

  fileSystems = {
    "/" = subvol "root";
    "/toplevel" = subvol "/";
    "/boot" = {
      device = "/dev/disk/by-uuid/B007-B007";
      fsType = "vfat";
      options = ["umask=027"];
    };

    "/extern" = {
      device = "/dev/disk/by-uuid/7d8d3ec9-b456-4e2a-9396-551dcaf7705b";
      fsType = "btrfs";
      options = ["noatime" "compress=zstd"];
    };
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
