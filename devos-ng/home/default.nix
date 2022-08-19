{
  self,
  inputs,
  ...
}:
with builtins;
with inputs.nixlib.lib; let
  inherit (inputs) digga;
  cfg = {
    imports = [
      (digga.lib.importExportableModules ./modules)
    ];
    
    # Modules to include that won't be exported meant importing modules from external flakes
    # Type: list of valid modules or anything convertible to it or path convertible to it
    modules = [
      { lib.m = self.lib; }
    ];
    
    # Modules to include in all hosts and export to homeModules output
    # Type: list of valid modules or anything convertible to it or path convertible to it
    exportedModules = [
    ];
    
    # Packages of paths to be passed to modules as specialArgs.
    # Type: attribute set
    importables = {
      profiles = digga.lib.rakeLeaves ./profiles;

      # Collections of profiles
      # Type: null or attribute set of list of paths or anything convertible to its or path convertible to it
      suites = with cfg.importables.profiles; {
        base = [ ];
      };
    };
    
    # HM users that can be deployed portably without a host.
    # Type: attribute set of HM user configs
    users = digga.lib.rakeLeaves ./users;
  };
in
  cfg
