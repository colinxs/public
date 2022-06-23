{
  inputs = {
    nix-home.url = "path:///home/colinxs/nix-home";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nix-home/nixpkgs-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nix-home,
    flake-utils,
    nixos-generators,
  }:
    with builtins;
    with nix-home.inputs.nixpkgs.lib; 
    let

      outputs = {
        nixosConfigurations = {
          nixos = nix-home.inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ (import ./configuration.nix) ];
          };
        };
      };
      
      systemOutputs = flake-utils.lib.eachDefaultSystem (system: 
      let  
      inherit (pkgs) lib mur;
      # pkgs = nix-home.legacyPackages."${system}";
      pkgs = nix-home.legacyPackages."${system}".pkgsUnstable;
      in
      {
          packages = {
            # nixosConfigurations = {
            #   generic = nix-home.inputs.nixpkgs.lib.nixosSystem {
            #     inherit system;
            #     modules = [ ./configuration.nix ];
            #   };
            # };
            qcow = nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix
              ];
              format = "qcow";
            };
            install-iso = nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix
              ];
              format = "install-iso";
            };
            iso = nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix
              ];
              format = "iso";
            };
            foo = nixos-generators.packages;
          };
          devShell = pkgs.mkShell {
            name = "nixos";
            packages = with pkgs; [
              qemu
              nixos-generators.packages."${system}".nixos-generators
            ];
          };
      });
    in
    outputs // systemOutputs;
  }
