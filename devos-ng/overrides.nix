channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.nixpkgs-unstable)
    cachix
    # dhall
    rage
    nix-index
    nixpkgs-fmt
    starship
    deploy-rs
    ;
}
