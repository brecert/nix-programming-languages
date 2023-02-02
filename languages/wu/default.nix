{ lib
, rustPlatform
, fetchCrate
, pkg-config
, cmake
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "wu";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mSwRIjsFkk0daWAhiBXSyVv6kogxCW2/u8QrM1ZjVzw=";
  };
  cargoHash = "sha256-WwlG6yIuKVpD2/kOFIZ+Y5rzJpOrskmEKEH/QsI3o20=";

  dontCargoCheck = true;

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "An expression oriented, gradually typed and mission-critical programming language.";
    homepage = "https://github.com/wu-lang/wu";
    license = licenses.mit;
    mainProgram = "wu";
  };
}
