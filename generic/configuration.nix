{
  config,
  lib,
  pkgs,
  modulePath,
  ...
}:
with builtins;
with lib; let
in {
  imports = [
    # (modulePath + "profiles/base.nix")
    ./hardware-extra.nix
    ./core.nix
    ./users.nix
    ./networking.nix
    ./graphical.nix
    ./services/ssh.nix
    # ./services/nfs.nix
    ./services/netdata.nix
  ];

  config = {
    # virtualisation = {
    #   podman = {
    #     enable = true;

    #     # Create a `docker` alias for podman, to use it as a drop-in replacement
    #     dockerCompat = true;

    #     # * Rootless can't use ZFS directly but the overlay needs POSIX ACL enabled for the underlying ZFS filesystem, ie., acltype=posixacl
    #     # extraPackages = [ pkgs.zfs ];
    #   };

    #   oci-containers = {
    #     backend = "podman";
    #     containers =
    #       {
    #         home-assistant = {
    #           image = "ghcr.io/home-assistant/home-assistant:stable";
    #           autoStart = true;
    #           # ports = [ "53" "3000" ];
    #           volumes = [
    #          "/etc/localtime:/etc/localtime:ro"
    #           ];
    #           extraOptions = ["--network=host"];
    #         };
    #       };
    #   };
    #   };
  };
}
