{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  nfsdPort = 2049; # tcp/udp (all linux)
  rpcbindPort = 111; # tcp/udp (all linux)
  mountdPort = 4000; # tcp/udp (varies)
  statdPort = 4001; # tcp/udp (varies)
  lockdPort = 4002; # tcp/udp (varies)
in {
  services.nfs.server = {
    enable = true;
    inherit mountdPort statdPort lockdPort;
    createMountPoints = true;
    exports = ''
      /export 10.0.0.0/8(rw,sync,no_substree_check,crossmnt,nohide,fdid=0)
      /export/private 10.0.0.0/8(rw,sync,no_substree_check)";
      /export/public *(ro,sync,no_substree_check,all_squash,insecure)";
    '';
  };
  fileSystems."/export/private" = {
    device = "/mnt/private";
    options = ["bind"];
  };
  fileSystems."/export/public" = {
    device = "/mnt/public";
    options = ["bind"];
  };
  networking.firewall.allowedTCPPorts = [2049 111 mountdPort statdPort lockdPort];
  networking.firewall.allowedUDPPorts = [2049 111 mountdPort statdPort lockdPort];
}
