{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, go
}:

buildGoModule rec {
  pname = "goplus";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "goplus";
    repo = "gop";
    rev = "v${version}";
    sha256 = "sha256-aWrVKAKTgqiccVf0QdCNebCHKqQOVnZYHtZWjsJnFvQ=";
  };

  vendorHash = "sha256-EXLYO11gQAdLB5ZL3B4yYo4HSfB4VLghDmB5d3x7Mqw=";

  # checks network and files..
  doCheck = false;

  # This is required for wrapProgram.
  allowGoReference = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export GOPROOT_FINAL=$out/share/gop

    go run cmd/make.go --install

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $GOPROOT_FINAL
    cp -a * $GOPROOT_FINAL
    
    mkdir -p $out/bin
    ln -s $GOPROOT_FINAL/bin/* $out/bin

    for bin in $out/bin/*; do
      wrapProgram $bin \
        --prefix PATH : ${lib.makeBinPath [ go ]}
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming language designed for engineering, STEM education, and data science.";
    homepage = "https://goplus.org/";
    license = licenses.asl20;
    mainProgram = "gop";
  };
}
