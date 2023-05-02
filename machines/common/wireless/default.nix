{ config, pkgs, lib, ... }: {

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
      "@home_ssid@" = { psk = "@home_psk@"; };
      "@jessica_ssid@" = { psk = "@jessica_psk@"; };
      "@dimas_ssid@" = { psk = "@dimas_psk@"; };
      "@bobcat_ssid@" = { psk = "@bobcat_psk@"; };
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
