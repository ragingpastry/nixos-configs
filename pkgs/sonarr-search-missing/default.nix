{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sonarr-search-missing";
  version = "unstable-2023-05-14";

  src = fetchFromGitHub {
    owner = "ragingpastry";
    repo = "sonarr-search-missing";
    rev = "c803835d9bc1280b5c1e7379ab4d1c00d1c96e23";
    hash = "sha256-aPlIZ+KIwlC7YkejclBz6fwKenv3c1LpSdHDcEDy6vg=";
  };

  vendorHash = "sha256-faEReqUjGwn2veN4sRd6zHPA00tt/IvNGXFzXYxO8To=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Silly little CLI tool built for fun";
    homepage = "https://github.com/ragingpastry/sonarr-search-missing";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
