{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHG4Iv17xEVEAJCXebBgXYMuQTOF3Hz2Z7x2+JnXnAS Colin Summers <me@colinxsummers.com>";
in
{
  users.users.root = {
    password = "";
    openssh.authorizedKeys.keys = [
      sshKey
    ];
  };
}


