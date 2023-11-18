{ callPackage
, mkRunner
, goplus ? callPackage ./default.nix {}
}: 

mkRunner "goplus" {
  run.inputs = [goplus];
  run.script = ''
    gop run $input
  '';
}
