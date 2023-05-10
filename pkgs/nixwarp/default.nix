{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nixwarp";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ragingpastry";
    repo = "nixwarp";
    rev = "d869bab0b5cf25834a1cd3c6d9ce244bd98042bf";
    hash = "sha256-HA4YwNXgQfcZQNnxO+B7FyhQFgU2Y0FB/i5vucBW77o=";
  };

  vendorHash = "sha256-b01mBpbV10jRxKwoZ4Cx4tMbzz4O+4ESlal9kImOGB4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Stupid nixos update CLI I made for fun";
    homepage = "https://github.com/ragingpastry/nixwarp";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
