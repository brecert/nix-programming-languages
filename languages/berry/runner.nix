{ callPackage
, mkRunner
, berry ? callPackage ./default.nix {}
}: 

mkRunner "berry" {
  run.inputs = [berry];
  run.script = ''
    berry $input
  '';
}
