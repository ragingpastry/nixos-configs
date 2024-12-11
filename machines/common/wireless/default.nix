{ config, pkgs, lib, ... }: {

  sops.secrets.wireless = {
    sopsFile = ../wireless_secrets.yaml;
    neededForUsers = true;
  };

  networking.networkmanager.enable = false;

  networking.wireless = {
    enable = true;
    extraConfig = ''
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
    '';
    secretsFile = config.sops.secrets.wireless.path;

    networks = {
      "MySpectrumWiFiC6-5G" = { psk = "ext:home_psk"; };
      "Tequila House" = { pskRaw = "ext:jessica_psk"; };
      "MyOptimum 64a789" = { pskRaw = "ext:dimas_psk"; };
      "bobcat" = { pskRaw = "ext:bobcat_psk"; };
      "Saturn" = { pskRaw = "ext:saturn_psk"; };
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
