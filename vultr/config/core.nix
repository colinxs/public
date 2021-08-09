{ config, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixos";
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;

  time.timeZone = "UTC";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo
    hashedPassword = "$6$zEjwd1mR1ffv5P4O$czYfFhPHS7zv0W1CvxcsP2MuHW4sUwjEhYElcIFffSnDcwQ7A5bjRAfUxrEFynsbjkSa5xpxDXFXCBY5u/ptv1";
  };
  
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  networking.firewall.allowedTCPPorts=[ 22 ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;
  
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
