{ lib
, system
, stdenv
, fetchFromGitHub
, makeWrapper
, wasmer
}:

let 
  inherit (lib.lists) reverseList;
  inherit (lib.strings) splitString concatStringsSep;
in
  stdenv.mkDerivation rec {
    pname = "onyx";
    version = "0.1.8-beta";

    src = fetchFromGitHub {
      owner = "onyx-lang";
      repo = "onyx";
      rev = "v${version}";
      hash = "sha256-P0AGLl3A1GjtMn5D4McyrksHn8tuBKrNrvqfT+UX4oM=";
    };

    ONYX_CC = "gcc";
    ONYX_ARCH = concatStringsSep "_" (reverseList (splitString "-" system));
    ONYX_USE_DYNCALL = 1;

    nativeBuildInputs = [
      wasmer
      makeWrapper
    ];

    buildInputs = [
      wasmer
    ];

    buildPhase = ''      
      ./build.sh compile
    '';

    installPhase = ''
      runHook preInstall

      export ONYX_INSTALL_DIR="$out"

      ./build.sh install

      wrapProgram $out/bin/onyx \
        --prefix ONYX_PATH : "$out"

      runHook postInstall
    '';
    
    
    meta = with lib; {
      description = "A modern language for WebAssembly";
      homepage = "https://github.com/onyx-lang/onyx";
      changelog = "https://github.com/onyx-lang/onyx/blob/${src.rev}/CHANGELOG";
      license = licenses.bsd2;
      mainProgram = "onyx";
      platforms = platforms.all;
    };
  }
