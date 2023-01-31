{ lib
, stdenv
, fetchFromGitHub
, nim
, gtk3
, webkitgtk
, gmp
, mpfr
, useMiniBuild ? true 
}:

assert !useMiniBuild -> gtk3 != null
                     && webkitgtk != null
                     && gmp != null
                     && mpfr != null;
  

stdenv.mkDerivation rec {
  pname = "arturo";
  version = "0.9.80";

  src = fetchFromGitHub {
    owner = "arturo-lang";
    repo = "arturo";
    rev = "v${version}";
    hash = "sha256-tOjkFI+MXVqt6lsoG786rugTmuqG9eFqDQESF2mOKOg=";
  };

  nativeBuildInputs = if useMiniBuild then [
    nim
  ] else [
    nim
    gtk3
    webkitgtk
    gmp
    mpfr
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