{
  inputs,
  cell,

  lib,
  pkg-config,
  buildGoModule
}:

let
  inherit (inputs) prometheus-podman-exporter;
  pname = "prometheus-podman-exporter";
in
pkgs.buildGoModule {
  inherit pname;
  version = "latest";
  src = prometheus-podman-exporter;
  nativeBuildInputs = [
    pkg-config
  ];
  vendorSha256 = null;
  enableParallelBuilding = true;
  doCheck = false;
  meta.mainProgram = pname;
}
