{ inputs, config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/crepe

    ../../profiles/tailscale-exit-node.nix

  ];

  boot = { kernelPackages = pkgs.linuxPackages_latest; };

  networking.hostName = "konishi";
  time.timeZone = "America/Chicago";

  services.xserver.enable = false;
  services.printing.enable = false;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = false;

  system.stateVersion = "22.11";

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/music";
      Address = "127.0.0.1";
    };
  };

  sops.secrets.acme_credentials_file = {
    sopsFile = ./secrets.yaml;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {

      email = "senior.crepe@gmail.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials_file.path;
    };

    certs."rivertuna.org" = {
      domain = "*.rivertuna.org";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials_file.path;
      group = "nginx";
    };
  };

  # This does nothing but we will leave it here just incase
  # ipv6 is actually disabled in hardware-configuration.nix
  # under kernelParams
  networking.enableIPv6 = false;


  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    defaultListenAddresses = [ ];

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts."navidrome.rivertuna.org" = {
      listenAddresses = [ "100.102.236.97" ];
      useACMEHost = "rivertuna.org";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
        proxyWebsockets = true;
      };
    };
  };

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
