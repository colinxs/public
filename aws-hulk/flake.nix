{
  inputs = {
    nix-home.url = "path:///home/colinxs/nix-home";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix-home, flake-utils }:

    with builtins;
    with nix-home.inputs.nixpkgs.lib;

    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs) lib mur;
        # pkgs = nix-home.legacyPackages."${system}";
        pkgs = nix-home.legacyPackages."${system}".pkgsUnstable;
        aws-hulk = import ./configuration.nix;
      in
      {
        nixosConfigurations = { inherit aws-hulk; };
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
        };
        devShell = pkgs.mkShell {
        };
      });
}
