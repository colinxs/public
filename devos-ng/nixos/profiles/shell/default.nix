{
  self,
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
in {
  programs.bash = {
    # Enable starship
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    # Enable direnv, a tool for managing shell environments
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };


  environment = {
    # Starship is a fast and featureful shell prompt
    # starship.toml has sane defaults that can be changed there
    shellInit = ''
      export STARSHIP_CONFIG=${
        pkgs.writeText "starship.toml"
        (fileContents ./starship.toml)
      }
    '';

    # TODO move to home-manager
    shellAliases = let
      ifSudo = lib.mkIf config.security.sudo.enable;
    in {
      # nix
      n = "nix";
      np = "n profile";
      npi = "n profile install";
      npr = "n profile remove";
      ns = "n search --no-update-lock-file";
      nsp = "n search --no-update-lock-file nixpkgs";
      nf = "n flake";
      nrb = ifSudo "sudo nixos-rebuild";
      nepl = "n repl '<nixpkgs>'";

      # fix nixos-option for flake compat
      nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

      # systemd
      stl = ifSudo "sudo systemctl";
      ustl = "systemctl --user";
      jtl = ifSudo "sudo journalctl";
      ujtl = "journalctl --user";

      # sudo
      s = ifSudo "sudo -E ";
      si = ifSudo "sudo -i";
      se = ifSudo "sudoedit";

      # git
      g = "git";

      # internet ip
      # TODO: explain this hard-coded IP address
      myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";
    };
  };
}
