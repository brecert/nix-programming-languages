{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... }@inputs: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = ["x86_64-linux"];

      perSystem = { pkgs, ... }: {
        packages = {
          dyon = pkgs.callPackage ./languages/dyon { };
          oak = pkgs.callPackage ./languages/oak { };
        };
      };
    };
}