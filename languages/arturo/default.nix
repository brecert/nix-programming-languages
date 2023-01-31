{ lib
, stdenv
, fetchFromGitHub
, nim
}:

stdenv.mkDerivation rec {
  pname = "arturo";
  version = "0.9.80";

  src = fetchFromGitHub {
    owner = "arturo-lang";
    repo = "arturo";
    rev = "v${version}";
    hash = "sha256-tOjkFI+MXVqt6lsoG786rugTmuqG9eFqDQESF2mOKOg=";
  };

  nativeBuildInputs = [
    nim
  ]; 

  patchPhase = ''
    runHook prePatch
    
    patchShebangs .
    export HOME=$(mktemp -d)

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    ./build.nims install mini

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv $HOME/.arturo $out

    runHook postInstall
  '';
}