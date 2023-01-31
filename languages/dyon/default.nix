{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "dyon";
  version = "0.48.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-UYY0AHIljzTSVDZVuS/6WxMxeGbZdG3P6g0sYzkyLJE=";
  };
  cargoHash = "sha256-/3oBih13JChVfksoZeXxKHDyFwljqBhxMDh1oz/c+XE=";

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
