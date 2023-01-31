{ lib
, stdenv
, fetchFromGitHub
, readline
, python3
}:

stdenv.mkDerivation rec {
  pname = "berry";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "berry-lang";
    repo = "berry";
    # normally we'd use the version as is, but given the comment after the major version makes building much easier and nothing else it's worth using here.
    rev = "10fba95c07f5cc3ce30f190163813185b897082c";
    hash = "sha256-lWyie8o1CU28B7Fcy3qC2mA5iWaRpElYo4zsuSRIEFo=";
  };

  prePatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ readline python3 ];
  
  installFlags = [ "DESTDIR=$(out)" "BINDIR=/bin" ];

  meta = with lib; {
    description = "An ultra-lightweight embedded scripting language optimized for microcontrollers.";
    homepage = "https://github.com/berry-lang/berry";
    license = licenses.mit;
    mainProgram = "berry";
  };
}