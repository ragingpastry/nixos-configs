{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../common/global
      ../common/users/crepe
      ../common/monitoring.nix

      ../../profiles/virtualization/docker.nix
      ../../profiles/arr.nix
      ../../profiles/plex.nix
    ];


  networking.hostName = "conjoiner"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  services.xserver.videoDrivers = [ "nvidia" ];
  networking.enableIPv6 = false;

  sops.secrets.acme_credentials_file = {
    sopsFile = ./secrets.yaml;
  };

  sops.secrets.sabnzbd_api_key = {
    sopsFile = ./secrets.yaml;
  };

  sops.secrets.cloudflare_tunnel_overseerr_credentials = {
    sopsFile = ./secrets.yaml;
    owner = "cloudflared";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
