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
      10.108.188.149 grafana.bigbang.dev
    '';
  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05";
}
