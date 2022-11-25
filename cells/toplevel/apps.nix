{ inputs
, cell
,
}:
let
  pkgs = inputs.nixpkgs;
  lib = pkgs.lib // builtins;
  callPackage = lib.callPackageWith (self // pkgs // { inherit lib inputs cell; } );
  self = with lib; with self; {
    npmlock2nix = callPackage inputs.npmlock2nix { };
    wrangler2 = callPackage ./wrangler2 { };
    prometheus-podman-exporter = callPackage ./prometheus-podman-exporter { };
  };
in
self
