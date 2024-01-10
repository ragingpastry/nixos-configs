{ inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/crepe
    ../common/wireless

    ../../profiles/virtualization/docker.nix
    ../../profiles/virtualization/libvirtd.nix
    ../../profiles/gnome.nix
    ../../profiles/nvidia-RTX-A2000.nix
    ../../profiles/work
    ../../profiles/steam.nix
  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;
  hardware.pulseaudio.enable = false;
  #hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };
  services.jack = {
    jackd.enable = true;
  };

  sound.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
    pulse.enable = true;
    #jack.enable = true;
  };
  services.flatpak.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 19132 19133 25565 ];
    allowedUDPPorts = [ 19132 4445 25565 41520 19133 ];
  }; 

  networking.hostName = "polis";
  #networking.nameservers = [ "1.1.1.1" ];
  networking.extraHosts =
  ''
    10.90.1.250 bl-vcsa00.cellar.bl
    10.15.11.46 jira.dev.blacklabel.mil
  '';
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
