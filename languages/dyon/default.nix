{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "dyon";
  version = "0.49.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1Sgd1ldaSePEs16j4cMDClVC+JKycWM3tPfb2bqBges=";
  };
  cargoHash = "sha256-cgDJcXygcmz+ETKh+M2jIT1oyZDCunKx4rt6q8YuGXo=";

  dontCargoCheck = true;

  buildPhase = ''
    cargo build --example dyonrun --release        
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./target/release/examples/dyonrun $out/bin
  '';

  meta = with lib; {
    description = "A rusty dynamically typed scripting language";
    homepage = "https://github.com/PistonDevelopers/dyon";
    license = licenses.asl20;
    mainProgram = "dyonrun";
  };
}
