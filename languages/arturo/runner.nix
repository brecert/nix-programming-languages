{ callPackage
, mkRunner
, arturo ? callPackage ./default.nix {}
}: 

mkRunner "arturo" {
  run.inputs = [arturo];
  run.script = ''
    arturo $input
  '';
}
