{ pkgs, config, ... }: {
  security.pki.certificates = [ "${pkgs.dod-certs}/dod-certs.pem" ];
  environment.systemPackages = with pkgs; [
    acsccid
    opensc
    pcsctools
    libusb
    pcsclite
  ];

  services.pcscd.enable = true;
}

