{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./configuration-extra.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixos";

  time.timeZone = "UTC";

  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo
  };
  
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  environment.systemPackages = with pkgs; [
    # Basic
    coreutils
    diffutils # For `cmp` and `diff`.
    findutils
    gnugrep
    gnused
    ncurses # For `tput`.
    htop

    # Archivers/Compression
    gnutar
    zstd
    unzip
    p7zip

    # Networking
    nmap
    iftop
    gitAndTools.gh # GitHub CLI
  ];
}
