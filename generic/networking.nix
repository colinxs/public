{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with pkgs.lib; let
in {
  networking.hostName = "nixos";
  # Generate with:  echo mini | md5sum | head -c 8
  networking.hostId = "8556b001";

  networking.enableIPv6 = true;

  # Disable wpa_supplicant and use networkmanager
  networking.wireless.enable = false;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  networking.firewall = {
    enable = false; # TODO

    allowPing = true;

    allowedTCPPorts = [
    ];
    allowedUDPPorts = [ 
    ];
  };
}
