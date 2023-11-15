{ callPackage
, mkRunner
, inko ? callPackage ./default.nix {}
}: 

mkRunner "inko" {
  run.inputs = [inko];
  run.script = ''
    inko run $input
  '';
}
