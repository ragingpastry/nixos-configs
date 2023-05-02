{ inputs, config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./plg.nix

    ../common/global
    ../common/users/crepe

    ../../profiles/tailscale-exit-node.nix

  ];


  boot = { kernelPackages = pkgs.linuxPackages_latest; };

  networking.hostName = "carter-zimmerman";
  time.timeZone = "America/Chicago";

  services.xserver.enable = false;
  services.printing.enable = false;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = false;

  system.stateVersion = "22.11";

  networking.enableIPv6 = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 80 443 ];
      };
    };
  };
}
