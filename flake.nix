{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = {
    nixpkgs,
    ...
  }: let
    eachSystem = fn: nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system: (fn {
      inherit system;
      pkgs = (import nixpkgs { inherit system; } );
    }));
  in {
    packages = eachSystem ({ pkgs, ... }: {
      setup = pkgs.callPackage ./setup.nix {};
    });
  };
}
