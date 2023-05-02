{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-99ap7B5EfMhuSGmT/JNI+CTPv7lTdjxibC0ndYWyNoA=";
  };

  vendorHash = "sha256-2Eb8FhbRu5M5u8HGa2bgAvZZkwHycBu8UiNKHG5/fFw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "AIO Prometheus Exporter for Prowlarr, Lidarr, Readarr, Radarr, and Sonarr";
    homepage = "https://github.com/onedr0p/exportarr";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
