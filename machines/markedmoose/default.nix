{ inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/landon
    ../common/users/crepe
    ../common/wireless

    ../../profiles/virtualization/docker.nix
    ../../profiles/virtualization/libvirtd.nix
    ../../profiles/gnome.nix
  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "markedmoose";
  networking.nameservers = [ "1.1.1.1" ];
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
