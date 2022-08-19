{ self, config, lib, pkgs, suites, profiles, ... }:

{
    ### root password is empty by default ###
    imports =
      suites.base
      ++ [
      ./hardware-configuration.nix
      ./hardware-extra.nix
      ./networking.nix
      
      ./services/containers.nix
      ];
    
    virtualisation.forwardPorts = [
      { from = "host"; host.port = 29190; guest.port = 22; }
      { from = "host"; host.port = 29191; guest.port = 19999; }
    ];
    services.qemuGuest.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.qemu.guestAgent.enable = true;
    virtualisation.qemu.options = [
      "-bios" "${pkgs.OVMF.fd}/FV/OVMF.fd"
    ];
    virtualisation.libvirtd.qemu.runAsRoot = true;
    virtualisation.kvmgt.enable = true;
    virtualisation.qemu.networkingOptions = [
      "-nic bridge,br=virbr0,model=virtio-net-pci,helper=/usr/libexec/qemu-bridge-helper"
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;
}
