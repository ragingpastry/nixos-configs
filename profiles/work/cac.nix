{ pkgs, config, ... }: {
  security.pki.certificateFiles = [ "${pkgs.dod-certs}/dod-certs.pem" ];
  environment.systemPackages = with pkgs; [
    acsccid
    opensc
    pcsctools
    libusb
    pcsclite
    p11-kit
  ];

  services.pcscd.enable = true;
}

