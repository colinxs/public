{
  description = "A very basic flake";


  nixConfig.extra-experimental-features = [ "nix-command" "flakes" ];
  nixConfig.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://colinxs.cachix.org"
  ];
  nixConfig.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "colinxs.cachix.org-1:N5myc56TmJpz5qxu9tQ8RBUWMuwTtkXTyLmWVhzsIvk="
  ];

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.prometheus-podman-exporter.url = "github:containers/prometheus-podman-exporter?ref=v1.2.0";
  inputs.prometheus-podman-exporter.flake = false;
  inputs.npmlock2nix.url = "github:nix-community/npmlock2nix";
  inputs.npmlock2nix.flake = false;
  # inputs.wrangler2.url = "github:cloudflare/wrangler2?ref=wrangler%402.4.2";
  # inputs.wrangler2.flake = false;
  inputs.wrangler2 = {
    flake = false;
    type = "github";
    owner = "cloudflare";
    repo = "wrangler2";
    ref = "wrangler@2.4.2";
  };

  outputs = inputs:
    let
      l = inputs.nixpkgs.lib // builtins;
    in
      with l;
      with inputs.std;
      growOn {
        inherit inputs;
        cellsFrom = ./cells;
        cellBlocks = [
          (blockTypes.functions "library")
          (blockTypes.runnables "apps")
          (blockTypes.installables "packages")
        ];
        debug = ["inputs" "std"];
      }
      {
        packages = harvest inputs.self ["toplevel" "apps"];
      };
}
