{ config
, lib
, pkgs
, ...
}:
with builtins;
with lib; let
in
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    layout = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Slim Gnome
  services.gnome.core-utilities.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    glxinfo
  ];
}
