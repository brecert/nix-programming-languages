{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    roc-lang = {
      url = "github:roc-lang/roc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, roc-lang, ... }@inputs: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = ["x86_64-linux"];
      transposition.lib.adHoc = true;

      perSystem = { self', pkgs, system, ... }:
        let
          # todo: make a scope for this?
          callPackage = pkgs.lib.callPackageWith (pkgs // self'.packages);
          roc = roc-lang.packages.${system}.default;
        in
        {
          lib = callPackage ./.nix/lib {};

          apps = pkgs.lib.mapAttrs
            (name: drv: { program = drv; })
            (self'.lib.importRunners (self'.lib.findRunnerFiles ./languages) callPackage);

          packages = {
            inherit roc;
            arturo = callPackage ./languages/arturo { };
            arturoFull = callPackage ./languages/arturo { useMiniBuild = false; };
            berry = callPackage ./languages/berry { };
            dyon = callPackage ./languages/dyon { };
            goplus = callPackage ./languages/goplus { };
            inko = callPackage ./languages/inko { };
            oak = callPackage ./languages/oak { };
            oakc = callPackage ./languages/oakc { };
            onyx = callPackage ./languages/onyx { };
            onyx-wasmer = callPackage ./languages/onyx { onyxRuntimeLibrary = "wasmer"; };
            rock = callPackage ./languages/rock { };
            wu = callPackage ./languages/wu { };
          };
        };
    };
}