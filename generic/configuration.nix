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
    ./hardware-configuration.nix
    ./hardware-extra.nix
    ./core.nix
    ./users.nix
    ./networking.nix
    ./graphical.nix
    # ./virtualization.nix
    ./services/ssh.nix
    # ./services/nfs.nix
    ./services/netdata.nix
  ];

  config = {
  };
}
