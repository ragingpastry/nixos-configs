{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nixwarp";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "ragingpastry";
    repo = "nixwarp";
    rev = "${version}";
    hash = "sha256-SHwgV5Ykn7BJ5DTAF4yU1aCFgHvYEhLO1Br1ZN7xfGc=";
  };

  vendorHash = "sha256-1L56awuqlaNCrwGNZ6eLCDqpKXD1DLhinP8/rYP+W+0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Stupid nixos update CLI I made for fun";
    homepage = "https://github.com/ragingpastry/nixwarp";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
