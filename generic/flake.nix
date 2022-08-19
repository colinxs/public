{
  inputs = {
    nix-home.url = "path:///home/colinxs/nix-home";

    nixos.url = "github:nixos/nixpkgs/nixos-22.05";
    
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      # inputs.nixpkgs.follows = "nix-home/nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixos";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # For accessing `deploy-rs`'s utility Nix functions
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos";
      # inputs.nixpkgs.follows = "nix-home/nixpkgs-unstable";
      inputs.utils.follows = "nix-home/flake-utils";
      inputs.flake-compat.follows = "nix-home/flake-compat";
    };

  };

  nixConfig = {
  };

  outputs = {
    self,
    nix-home,
    nixos,
    nixpkgs,
    flake-utils,
    nixos-generators,
    deploy-rs,
  }:
    with builtins;
    with nixos.lib;
    let
      libDeploy = deploy-rs.lib;

      systems = [ "x86_64-linux" ];

      outputs = {
        nixosConfigurations = {
          nixos = nixosSystem {
            system = "x86_64-linux";
            modules = [
              # (import ./configuration.nix)
              ./configuration.nix
            ];
          };
        };

        deploy.nodes.nixos-example = {
          hostname = "10.88.0.89";
          autoRollback = true;
          magicRollback = true;
          profiles.system = {
            user = "root";
            sshUser = "root";
            fastConnection = true; # TODO
            path = libDeploy.x86_64-linux.activate.nixos self.nixosConfigurations.nixos;
          };
        };
        # This is highly advised, and will prevent many possible mistakes
        checks = mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
        
        colmena = {
          meta = {
            nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          };
          nixos-example = { name, nodes, config, lib, pkgs, ... }: {
            imports = [ ./configuration.nix ];
            deployment = {
              targetHost = "10.88.0.10";
              targetUser = "root";
            };
          };
        };
      };

      systemOutputs = flake-utils.lib.eachSystem systems (system: let
        # pkgs = nix-home.legacyPackages."${system}";
        # pkgs = nix-home.legacyPackages."${system}".pkgsUnstable;
        pkgs = nixos.legacyPackages."${system}";
        # pkgs = nixpkgs.legacyPackages."${system}";
        images = listToAttrs (map (format: {
          name = format;
          value = nixos-generators.nixosGenerate {
            inherit format pkgs;
            modules = [ ./configuration.nix ];
          };
        }) [
          "iso"
          "install-iso"
          "vm"
        ]);
      in {
        packages = images // {
        };

        devShells.default = pkgs.mkShell {
          name = "nixos-dev";
          packages = with pkgs; [
            qemu
            nixos-generators.packages."${system}".nixos-generators
          ];
        };
      });
    in
      outputs // systemOutputs;
}
