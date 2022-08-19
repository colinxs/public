{ config
, lib
, pkgs
, ...
}:
with builtins;
with lib; let
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure swap file. Sizes are in megabytes. Default swap is
  # max(1GB, sqrt(RAM)) = 1024. If you want to use hibernation with
  # this device, then it's recommended that you use
  # RAM + max(1GB, sqrt(RAM)) = 32435.000.
  swapDevices = [
    {
      device = "/swapfile";
      size = 5096;
    }
  ];
}
