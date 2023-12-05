{ lib
, system
, stdenv
, fetchFromGitHub
, makeWrapper
, wasmer
, tezos-rust-libs # we just need the wasmer c api but this has a cache available
, onyxRuntimeLibrary ? "none"
}:

assert onyxRuntimeLibrary == "none" || onyxRuntimeLibrary == "wasmer";

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

    nativeBuildInputs = [ makeWrapper ]
      ++ lib.optionals (onyxRuntimeLibrary == "wasmer") [ wasmer ] ;

    buildInputs = []
      ++ lib.optionals (onyxRuntimeLibrary == "wasmer") [ wasmer ];

    buildPhase = ''
      runHook preBuild
      
      ${lib.optionalString (onyxRuntimeLibrary == "wasmer") ''
        export ONYX_RUNTIME_LIBRARY="wasmer"
        export HOME="$PWD/.home"
        mkdir -p $HOME/.wasmer/lib
        cp "${tezos-rust-libs}/lib/tezos-rust-libs/libwasmer.a" "$HOME/.wasmer/lib/libwasmer.a"
      ''}
      
      ./build.sh compile

      runHook postBuild      
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
