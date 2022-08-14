{
  self,
  inputs,
  config,
  ...
}:
with builtins;
with inputs.nixlib.lib; let
  inherit (inputs) digga;
in {
  hostDefaults = {
    imports = [
      (digga.lib.importExportableModules ./modules)
    ];

    system = "x86_64-linux";

    # Channel this host should follow
    channelName = "nixos";

    # Modules to include that won't be exported meant importing modules from external flakes
    # Type: list of valid modules or anything convertible to it or path convertible to it
    modules = with inputs; [
      {lib.m = self.lib;}
      inputs.digga.nixosModules.bootstrapIso
      inputs.digga.nixosModules.nixConfig
      inputs.home-manager.nixosModules.home-manager
      inputs.agenix.nixosModules.age
    ];

    # Modules to include in all hosts and export to nixosModules output
    # Type: list of valid modules or anything convertible to it or path convertible to it
    exportedModules = [
    ];
  };

  imports = [
    (digga.lib.importHosts ./hosts)
  ];

  hosts = {
    NixOS = {
    };
  };

  # Packages of paths to be passed to modules as specialArgs.
  # Type: attribute set
  importables = rec {
    profiles = digga.lib.rakeLeaves ./profiles // {
      users = digga.lib.rakeLeaves ./users;
    };
    suites = with profiles; rec {
      base = [
        profiles.core
        profiles.shell
        profiles.ssh
        profiles.netdata
        profiles.cachix
        # profiles.graphical
        # profiles.nfs
        users.admin
        users.root
      ];
    };
  };
}
