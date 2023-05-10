{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.0.0-edge.2023-05-10";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-0bNTBIj6dQKyml/etyP7hKMlFU71SSamJa3qtseFwLA=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-Ct1hftgMYAF8DPdnYTB1QQYD0HGC4wifIbMX+TrgDdk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = with lib; {
    description = "Instant, easy, predictable shells and containers.";
    homepage = "https://www.jetpack.io/devbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };


}
