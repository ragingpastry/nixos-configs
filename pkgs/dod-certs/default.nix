{ stdenv, pkgs }:
stdenv.mkDerivation rec {
  pname = "dod-certs";
  version = "0.1.0";

  src = pkgs.fetchzip {
    url =
      "https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_DoD.zip";
    sha256 = "O0Shnd2F1JRXjzjgAMv6BNAUo+KPzC4wJ2lkpLf5iSc=";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.openssl ];

  buildPhase = ''
    openssl pkcs7 -print_certs -in certificates_pkcs7_v5_12_dod_pem.p7b -out certificate.cer
  '';

  installPhase = ''
    mkdir $out
    cp certificate.cer $out/dod-certs.pem
  '';
}
