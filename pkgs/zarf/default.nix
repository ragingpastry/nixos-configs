{ lib
, buildGoModule
, fetchFromGitHub
  #, source
}:

buildGoModule rec {
  #inherit (source) pname version src vendorHash;
  pname = "zarf";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-AHS9V0vPTA1ltBo6TynZfWjg5eCY1tB7wn4z8WG2EtQ=";
  };

  vendorHash = "sha256-d2dD02L/Lr3/ccha5SlxMmEVNBsTeaLFqIC5BuW0tZQ=";
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
