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
    ../../profiles/minecraft-server.nix
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

  services.flatpak.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 19132 19133 25565 ];
    allowedUDPPorts = [ 19132 4445 25565 41520 19133 ];
  }; 

  networking.hostName = "polis";
  networking.nameservers = [ "1.1.1.1" ];
  #networking.extraHosts =
  #''
  #  10.15.8.129 gitlab.dev.blacklabel.mil registry.dev.blacklabel.mil
  #'';
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
