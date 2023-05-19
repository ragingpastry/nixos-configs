{ lib
, buildGoModule
, fetchFromGitHub
  #, source
}:

buildGoModule rec {
  #inherit (source) pname version src vendorHash;
  pname = "zarf";
  version = "0.26.4";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-uY29LfjflV25/mE6BplV6I+scoD1f0lJ4rnWfTF7Vd0=";
  };

  vendorHash = "sha256-OC4g8gOzraoCEPoYFQKBTm9mjelZ6Mtsb5kgGhFCo2g=";
  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
  '';

  checkPhase = "";

  ldflags = [ "-s" "-w" "-X" "github.com/defenseunicorns/zarf/src/config.CLIVersion=${src.rev}" "-X" "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.rev}" "-X" "k8s.io/component-base/version.gitCommit=${src.rev}" "-X" "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z" ];

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    homepage = "https://github.com/defenseunicorns/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
