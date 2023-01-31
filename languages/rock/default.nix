{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages_13
, libffi
, libxml2
, zlib
, ncurses
}:

rustPlatform.buildRustPackage rec {
  pname = "rock";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Champii";
    repo = "Rock";
    rev = "v${version}";
    sha256 = "sha256-NdjxlBzkTGp+RS0z9eZYICFIqEti+4lv7By5eL+HufE=";
  };
  cargoSha256 = "sha256-7jkRjr2W767wGKdIambw70t/6okkMs7O1xgaHRbEgsM=";

  nativeBuildInputs = [ llvmPackages_13.llvm ];
  buildInputs = [ libffi libxml2 zlib ncurses ];

  # fails due to filesystem access
  doCheck = false;

  meta = with lib; {
    description = "A native language made with Rust and LLVM.";
    homepage = "https://github.com/Champii/Rock";
    license = licenses.gpl3Only;
  };
}