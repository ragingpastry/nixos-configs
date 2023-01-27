{ inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/crepe
    ../common/wireless

    ../../profiles/virtualization/docker.nix
    ../../profiles/gnome.nix
    ../../profiles/nvidia-RTX-A2000.nix
    ../../profiles/work
  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "polis";
  networking.extraHosts =
    ''
      3.32.170.106    development-keycloak.blacklabel.dso.mil
    '';
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
