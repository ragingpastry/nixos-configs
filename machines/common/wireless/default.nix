{ config, pkgs, lib, ... }:
{

  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.networkmanager.enable = false;

  networking.wireless = {
    enable = true;
    extraConfig = ''
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
    '';
    environmentFile = config.sops.secrets.wireless.path;
    
    networks = {
      "@home_ssid@" = {
        psk = "@home_psk@";
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
  };

  users.groups.network = { };

}
