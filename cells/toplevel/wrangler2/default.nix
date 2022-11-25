{
  inputs,
  cell,

  lib,
  npmlock2nix
}:

let
in
npmlock2nix.build {
  src = inputs.wrangler2;
  pname = "wrangler";
  version = "latest";
  installPhase = "cp -r dist $out";
  buildCommands = [ "npm run build" ];
}
