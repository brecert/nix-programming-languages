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
  version = "0.9.83";

  src = fetchFromGitHub {
    owner = "arturo-lang";
    repo = "arturo";
    rev = "v${version}";
    hash = "sha256-a4bvXL7mCVJZmtvPhPzsl34iCt/44+kIaF54Yd6Lup4=";
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