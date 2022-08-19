{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
in {
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };
  networking.firewall.allowedTCPPorts = [22];
}
