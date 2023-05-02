{ stdenv, pkgs }:
stdenv.mkDerivation rec {
  pname = "dod-certs";
  version = "0.1.0";

  src = pkgs.fetchzip {
    url =
      "https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_DoD.zip";
    sha256 = "eY1sG/T77vIk2eNz9vMYxX7KXwAq5sFKpfLAW/UwtoE=";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.openssl ];

  buildPhase = ''
    openssl pkcs7 -print_certs -in certificates_pkcs7_v5_11_dod_pem.p7b -out certificate.cer
  '';

  installPhase = ''
    mkdir $out
    cp certificate.cer $out/dod-certs.pem
  '';
}
