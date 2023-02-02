{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "goplus";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "goplus";
    repo = "gop";
    rev = "v${version}";
    sha256 = "sha256-T/+Em/FFwsuVvZPDNDNmxjKRA1AMbPwyRjiNmylUUGI=";
  };

  vendorHash = "sha256-godYSVVcMdUlFUp/f9QGIGvVgbIlXoLl69bgp2LM0mI=";

  # checks network and files..
  doCheck = false;

  meta = with lib; {
    description = "A programming language designed for engineering, STEM education, and data science.";
    homepage = "https://goplus.org/";
    license = licenses.asl20;
    mainProgram = "gop";
  };
}
