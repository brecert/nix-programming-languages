{ callPackage
, mkRunner
, dyon ? callPackage ./default.nix {}
}: 

mkRunner "dyon" {
  run.inputs = [dyon];
  run.script = ''
     dyonrun $input
  '';
}
