{ stdenv, lib, pkgs, coreutils, findutils, gnugrep }:
stdenv.mkDerivation rec {
  pname = "assumeeksrole";
  version = "0.1.0";

  src = pkgs.fetchurl {
    url =
      "https://gitlab.90cos.cdl.af.mil/bl2/iac/supernova/bl-u/-/snippets/26/raw/main/assumeEksRole.sh";
    sha256 = "";
  };

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.installShellFiles ];

  installPhase = ''
    mkdir $out/bin
    chmod +x assumeEksRole.sh
    cp assumeEksRole.sh $out/bin/assumeEksRole.sh
    wrapProgram "$out/bin/assumeEksRole.sh" --set PATH ${lib.makeBinPath [ coreutils findutils gnugrep ]}
  '';
}
