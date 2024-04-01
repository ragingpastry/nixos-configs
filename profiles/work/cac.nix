{ pkgs, config, ... }: {
  security.pki.certificateFiles = [ "${pkgs.dod-certs}/dod-certs.pem" ];
  environment.systemPackages = with pkgs; [
    acsccid
    opensc
    pcsctools
    libusb
    pcsclite
    p11-kit
    pcscliteWithPolkit.out
  ];

  services.pcscd.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_card" &&
        subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
    });
    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
        subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
    });
  '';
}

