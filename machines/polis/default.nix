{ inputs, lib, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix

        ../common/global
        ../common/users/crepe
        ../common/wireless

        ../../profiles/virtualization/docker.nix
        ../../profiles/gnome.nix
        ../../profiles/nvidia-RTX-A2000.nix
        ../../profiles/cac.nix
    ];

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
    };

    networking.hostName = "polis";
    time.timeZone = "America/Chicago";

    system.stateVersion = "22.05";
}
