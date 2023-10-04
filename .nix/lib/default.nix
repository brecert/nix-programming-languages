{ lib
, nushell
, writeTextFile
}:

let 
  self = {
    nu = {
      nuStringEscape = stringToEscape:
        let 
          strings = ["\"" "\'" "\\" "\/" "\n" "\t"];
          replaceWith = builtins.map (string: "\\${string}") strings;
        in
          builtins.replaceStrings strings replaceWith stringToEscape;

      asNuString = string:
        ''"${self.nu.nuStringEscape string}"'';

      mkNushellApplication =
        { name
        , text
        , runtimeInputs ? [ ]
        , meta ? { }
        }:
        writeTextFile {
          inherit name meta;
          executable = true;
          destination = "/bin/${name}";
          allowSubstitutes = true;
          preferLocalBuild = false;
          text = ''
            #!${nushell}/bin/nu
            let _nix_runtime_inputs = [${lib.concatMapStringsSep " " (s: self.nu.asNuString (toString (lib.getBin s) + "/bin")) runtimeInputs}]
            $env.PATH = ($env.PATH | prepend $_nix_runtime_inputs)
            
            ${text}
          '';
        };
    };

    mkRunner = name: { run, ... }@attrs:
        let
          reservedAttrs = [
            "run"
            "name"
            "text"
            "runtimeInputs"
          ];
          
          extraAttrs = removeAttrs attrs reservedAttrs;


        in
          self.nu.mkNushellApplication ({
            name = "${name}-runner";
            runtimeInputs = run.inputs;
            text = ''
              def main [input:path] {
                ${run.script}
              }
            '';
          } // extraAttrs);

    findRunnerFiles = inDir:
      (lib.filterAttrs 
        (name: path: builtins.pathExists path)
        (builtins.mapAttrs 
          (name: type: inDir + "/${name}/runner.nix") 
          (builtins.readDir inDir)
      ));

    importRunners = withRunners: callPackage:
      lib.mapAttrs'
        (name: path: lib.nameValuePair "${name}-runner" (callPackage path { inherit (self) mkRunner; }))
        withRunners;
  };
in 
  self