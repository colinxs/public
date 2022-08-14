{ config, lib, pkgs, self, ... }:

with builtins;
with lib;

let
in
{
  imports = [
  ];

  system.stateVersion = "22.05";

  # This is just a representation of the nix default
  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # TODO broken?
  # system.copySystemConfiguration = true;

  environment = {

    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
      pciutils
      
      binutils
      coreutils
      curl
      neovim
      wget
      direnv
      dnsutils
      fd
      git
      bottom
      jq
      manix
      moreutils
      nix-index
      nmap
      ripgrep
      tealdeer
      whois
    ];

  };

  fonts.fonts = with pkgs; [ powerline-fonts dejavu_fonts ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "DejaVu Sans Mono for Powerline" ];
    sansSerif = [ "DejaVu Sans" ];
  };

  nix = {
    # Improve nix store disk usage
    # autoOptimiseStore = true;
    # optimise.automatic = true;

    # Give root user and wheel group special Nix privileges.
    trustedUsers = [ "root" "@wheel" ];
   
    # Let everyone connect to nix-daemon
    allowedUsers = [ "*" ];

    # Improve nix store disk usage
    gc.automatic = true;

    # Prevents impurities in builds
    useSandbox = true;

    # Generally useful nix option defaults
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      builders-use-substitutes = true
    '';
    
    distributedBuilds = true;
    buildMachines = [
      # TODO
      # {
      #   hostName = "ultron.home.colinxs.com";
      #   system = "x86_64-linux";
      #   maxJobs = 24;
      #   speedFactor = 10;
      #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      # }
    ];
  };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;
}
