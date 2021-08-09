{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05"; 
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
