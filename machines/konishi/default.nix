{ inputs, config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./plg.nix

    ../common/global
    ../common/users/crepe

    ../../profiles/tailscale-exit-node.nix
    ../../profiles/virtualization/docker.nix

  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };

  networking.hostName = "konishi";
  time.timeZone = "America/Chicago";

  services.xserver.enable = false;
  services.printing.enable = false;

  # Enable sound.
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = false;

  system.stateVersion = "23.11";

  sops.secrets.acme_credentials_file = {
    sopsFile = ./secrets.yaml;
  };

  # This does nothing but we will leave it here just incase
  # ipv6 is actually disabled in hardware-configuration.nix
  # under kernelParams
  #networking.enableIPv6 = false;

  networking.firewall = {
    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 80 443 9002 ];
      };
    };
  };

}
