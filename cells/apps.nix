{
  inputs,
  cell,
}:
let
    l = inputs.nixpkgs.lib // builtins;
    inherit (inputs) prometheus-podman-exporter;
    pname = "prometheus-podman-exporter";
in
with l; {

  prometheus-podman-exporter = buildGoModule {
    inherit pname;
    version = "latest";
    src = prometheus-podman-exporter;
    vendorSha256 = null;
    enableParallelBuilding = true;
    doCheck = false;
    meta.mainProgram = pname;
  };



}
