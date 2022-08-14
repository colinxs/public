{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  username = "admin";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHG4Iv17xEVEAJCXebBgXYMuQTOF3Hz2Z7x2+JnXnAS Colin Summers <me@colinxsummers.com>";
in {
  users.groups."${username}" = {
    gid = 1000;
  };

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    # createHome = true;

    uid = 1000;
    group = username;

    extraGroups = [
      username
      "wheel"
      "networkmanager"
    ];

    hashedPassword = "$6$x2N83At2a4Tmny0F$oOGC0uwcuWtUDyI66qx9VXIhl2C90YHABxPOCXNIF3eiiynakwUwl6BiUIav8itlHZ59M77n5qxQdkSiF7Hah0"; # "admin"
    openssh.authorizedKeys.keys = [
      sshKey
    ];
  };

  nix.settings.extra-trusted-users = [username];
}
