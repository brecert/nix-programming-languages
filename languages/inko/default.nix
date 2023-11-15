{ lib
, fetchFromGitHub
, rustPlatform
, llvmPackages_15
, libffi
, zlib
, git
, pkg-config
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "inko";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NptfVWXwbv09Lpq067nqXSO9wlcsS55zw4AxmrO5n80=";
  };

  cargoHash = "sha256-bhd0qJ0KGGdd428bSdw4VCcMN8bZTOnHYSVbgQzgkBs=";

  doCheck = false;

  nativeBuildInputs = [
    llvmPackages_15.libllvm
    git
    pkg-config
  ];

  # TODO: Investigate why there's a dependency on xml2 and ncurses.
  buildInputs = [
    zlib
    libffi
    libxml2
    ncurses
  ];

  buildPhase = ''
    make build PREFIX="$out"
  '';

  installPhase = ''
    make install PREFIX="$out"
  '';

  meta = with lib; {
    description = "A language for building concurrent software with confidence";
    homepage = "https://github.com/inko-lang/inko";
    license = licenses.mpl20;
  };
}