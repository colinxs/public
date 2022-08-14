{ config, pkgs, ... }:

with builtins;
with pkgs.lib;

let
in

{
  users.users.admin = {
    isNormalUser  = true;
    hashedPassword = "$6$etrTtX.WaGKll1Zs$fK9K8wDJ8SY0tTbySSL8b7lNmXfQxnLOmcrMITiG41JZvWix9nN6RE4QW9bZggdTsFuVH73Lq7aBxHtrY5JBS.";
    openssh.authorizedKeys.keys  = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHG4Iv17xEVEAJCXebBgXYMuQTOF3Hz2Z7x2+JnXnAS Colin Summers <me@colinxsummers.com>" ];
    extraGroups  = [ "wheel" ];
    home  = "/home/admin";
  };

  networking = {
    hostName = "aws-hulk";
    hostId = "c4ca91f0";
    enableIPv6 = true;
  };

  system.stateVersion = "21.11";

  systemd.services.podman-adguard-home.serviceConfig = {
    Wants = [ "network-online.target" "default.target" ];
    After = [ "network-online.target" "default.target" ];
    # TimeoutStartSec = pkgs.lib.hiPrio 5;
  };
  virtualisation = {
    podman = {
      # enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # * Rootless can't use ZFS directly but the overlay needs POSIX ACL enabled for the underlying ZFS filesystem, ie., acltype=posixacl
      # extraPackages = [ pkgs.zfs ];
    };

    oci-containers = {
      # backend = "podman";
      containers =
        let
          configFile = pkgs.writeTextFile {
            name = "AdguardHome.yaml"; 
            text = builtins.toJSON (import ./AdguardHome.nix);
            destination = "/AdguardHome.yaml";
          };
        in
        {
          adguard-home = {
            image = "docker.io/adguard/adguardhome:latest";
            autoStart = true;
            # ports = [ "53" "3000" ];
            volumes = [ "${configFile}:/opt/adguardhome/conf:ro" ];
            extraOptions = ["--network=host"];
          };
        };
    };
    };
  }

