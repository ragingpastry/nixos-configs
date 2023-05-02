{ inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/crepe
    ../common/wireless

    ../../profiles/virtualization/docker.nix
    ../../profiles/virtualization/libvirtd.nix
    ../../profiles/gnome.nix
  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  networking.hostName = "pattern-juggler";
  networking.nameservers = [ "1.1.1.1" ];
  #networking.extraHosts =
  #  ''
  #  '';
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
