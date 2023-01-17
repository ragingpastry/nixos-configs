{ stdenv, pkgs }:
stdenv.mkDerivation rec {
  pname = "dod-certs";
  version = "0.1.0";

  src = pkgs.fetchzip {
    url =
      "https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_DoD.zip";
    sha256 = "7+LpM7b2AvRbWZo3XtIH4Hm98Iid6L4fVuNKvTHwi2o=";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.openssl ];

  buildPhase = ''
    openssl pkcs7 -print_certs -in Certificates_PKCS7_v5.9_DoD.pem.p7b -out certificate.cer
  '';

  installPhase = ''
    mkdir $out
    cp certificate.cer $out/dod-certs.pem
  '';
}
