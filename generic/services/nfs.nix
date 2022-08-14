{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  nfsdPort = 2049; # tcp/udp (IANA)
  rpcbindPort = 111; # tcp/udp (IANA)
  mountdPort = 20048; # tcp/udp (IANA)
  rdmaPort = 20049; # tcp/udp (IANA)
  statdPort = 20050; # tcp/udp (varies)
  lockdPort = 20051; # tcp/udp (varies)
  nfscbPort = 20052; # tcp/udp (varies)
in {
  boot.kernelParams = [
    "nfs.callback_tcpport=${nfscbPort}"
  ];
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
  networking.firewall.allowedTCPPorts = [2049 111 mountdPort rdmaPort statdPort lockdPort nfscbPort ];
  networking.firewall.allowedUDPPorts = [2049 111 mountdPort rdmaPort statdPort lockdPort nfscbPort ];
}
