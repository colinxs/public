{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
in {
  services.netdata.enable = true;
  networking.firewall.allowedTCPPorts = [9090];
}
