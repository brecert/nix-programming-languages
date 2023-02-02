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
          arturo = pkgs.callPackage ./languages/arturo { };
          arturoFull = pkgs.callPackage ./languages/arturo { useMiniBuild = false; };
          berry = pkgs.callPackage ./languages/berry { };
          dyon = pkgs.callPackage ./languages/dyon { };
          goplus = pkgs.callPackage ./languages/goplus { };
          oak = pkgs.callPackage ./languages/oak { };
          oakc = pkgs.callPackage ./languages/oakc { };
          rock = pkgs.callPackage ./languages/rock { };
        };
      };
    };
}