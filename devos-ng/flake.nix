{
  description = "A DevOS example. And also a digga test bed.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
    extra-trusted-public-keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    ####
    #### Only needed to pin transitive dependencies
    ####
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    nixlib.url = "github:nix-community/nixpkgs.lib";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    beautysh.url = "github:lovesegfault/beautysh";
    beautysh.inputs.utils.follows = "flake-utils";
    beautysh.inputs.nixpkgs.follows = "nixos";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixos";
    devshell.inputs.flake-utils.follows = "flake-utils";

    ####
    ####
    ####

    nixos.url = "github:nixos/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.latest.follows = "nixos-unstable";
    digga.inputs.nixpkgs-unstable.follows = "nixos-unstable";
    digga.inputs.nixlib.follows = "nixlib";
    digga.inputs.deploy.follows = "deploy";
    digga.inputs.home-manager.follows = "home-manager";
    digga.inputs.flake-compat.follows = "flake-compat";
    digga.inputs.flake-utils-plus.follows = "flake-utils-plus";
    digga.inputs.devshell.follows = "devshell";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixos";
    home-manager.inputs.utils.follows = "flake-utils";
    home-manager.inputs.flake-compat.follows = "flake-compat";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";
    deploy.inputs.utils.follows = "flake-utils";
    deploy.inputs.flake-compat.follows = "flake-compat";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";
    nvfetcher.inputs.flake-utils.follows = "flake-utils";
    nvfetcher.inputs.flake-compat.follows = "flake-compat";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixos";
    nixos-generators.inputs.nixlib.follows = "nixlib";
  };

  outputs = {
    self,
    flake-utils,
    flake-compat,
    nixlib,
    flake-utils-plus,
    beautysh,
    devshell,
    # ----------------
    nixos,
    nixos-unstable,
    nixpkgs-unstable,
    digga,
    home-manager,
    deploy,
    agenix,
    nvfetcher,
    nixos-generators,
  } @ inputs:
    with builtins;
    with nixlib; let
    in
      digga.lib.mkFlake {
        inherit self inputs;

        supportedSystems = ["aarch64-linux" "i686-linux" "x86_64-linux"];

        # nixpkgs config for all channels
        channelsConfig = {
          allowUnfree = true;
        };

        channels = rec {
          nixos = {
            imports = [(digga.lib.importOverlays ./overlays)];
            overlays = [
              # (channels: final: prev: {
              # })
              # (final: prev: {
              # })
              ./overrides.nix
            ];
            # config = {};
            # patches = [];
          };
          nixos-unstable = {
            imports = [(digga.lib.importOverlays ./overlays)];
            overlays = [
              ./overrides.nix
            ];
          };
          nixpkgs-unstable = {
            imports = [(digga.lib.importOverlays ./overlays)];
            overlays = [
            ];
          };
        };

        lib = import ./lib {lib = digga.lib // nixos.lib;};

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              m = self.lib;
            });
          })

          agenix.overlay
          nvfetcher.overlay

          (import ./pkgs)
        ];

        nixos = ./nixos;
        home = ./home;
        devshell = ./devshell;

        # # TODO: similar to the above note: does it make sense to make all of
        # # these users available on all systems?
        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {};
      };
}
