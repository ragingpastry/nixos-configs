{ config, pkgs, lib, ... }:
{
    services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = false;
        desktopManager.gnome.enable = true;
    };
}