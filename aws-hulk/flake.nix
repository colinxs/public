{
  inputs = {
    nix-home.url = "path:///home/colinxs/nix-home";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix-home, flake-utils }:

    with builtins;
    with nix-home.inputs.nixpkgs.lib;

    let
      outputs = {
        nixosConfigurations = nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
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
            amazon = nix-home.inputs.nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix 
              ];
              format = "amazon";
            };
            qcow = nix-home.inputs.nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix 
              ];
              format = "qcow";
            };
            vm = nix-home.inputs.nixos-generators.nixosGenerate {
              inherit pkgs;
              modules = [
                ./configuration.nix 
              ];
              format = "vm";
            };
          };
          devShell = pkgs.mkShell {
          };
        });
    in
    outputs // systemOutputs;
}
