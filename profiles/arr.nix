{ config, pkgs, lib, ... }: {
  imports = [ ../modules/exportarr ];
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.sabnzbd = {
    enable = true;
    group = "media";
  };
  services.prowlarr = {
    enable = true;
  };
  services.exportarr.lidarr = {
    enable = true;
    config = "/var/lib/lidarr/.config/Lidarr/config.xml";
  };
  services.exportarr.sonarr = {
    enable = true;
    additionalMetrics = true;
    config = "/var/lib/sonarr/.config/NzbDrone/config.xml";
  };
  services.exportarr.sabnzbd = {
    enable = true;
    config = "/var/lib/sabnzbd/sabnzbd.ini";
  };
  services.exportarr.prowlarr = {
    enable = true;
    config = "/var/lib/prowlarr/config.xml";
  };
  services.exportarr.radarr = {
    enable = true;
    config = "/var/lib/radarr/.config/Radarr/config.xml";
  };

  networking.firewall = {
    enable = true;
    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 80 443 9707 9708 9709 9710 9711 9712 ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    exportarr
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {

      email = "senior.crepe@gmail.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials_file.path;
    };

    certs."nickwilburn.com" = {
      domain = "*.nickwilburn.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials_file.path;
      group = "nginx";
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    defaultListenAddresses = [ ];

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts."radarr.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sonarr.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
        proxyWebsockets = true;
      };
    };

    virtualHosts."lidarr.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sabnzbd.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };

    virtualHosts."prowlarr.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
        proxyWebsockets = true;
      };
    };

    virtualHosts."overseerr.nickwilburn.com" = {
      listenAddresses = [ "0.0.0.0" ];
      useACMEHost = "nickwilburn.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
        proxyWebsockets = true;
      };
    };

  };

  users.groups.media = { };

  systemd.services.media-permissions-fix = {
    description = "Fix permissions on /media";

    after = [ "sabnzbd.service" ];
    wants = [ "sabnzbd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      echo "Configuring SabNZBD hostname in /var/lib/sabnzbd/sabnzbd.ini"
      sed -i 's/^host_whitelist.*/host_whitelist = sabnzbd.nickwilburn.com/' /var/lib/sabnzbd/sabnzbd.ini
      echo "Ensuring media user has read/write access to /media folder"
      chown -R :media /media/TV
      chown -R :media /media/Music
      chown -R :media /media/Movies
      chown -R :media /var/lib/sabnzbd
      chmod g+w /media/TV
      chmod g+w /media/Music
      chmod g+w /media/Movies
      find /var/lib/sabnzbd -type d -exec chmod 770 ${"{}"} +
      find /var/lib/sabnzbd/Downloads/complete /var/lib/sabnzbd/Downloads/incomplete -type f -exec chmod 660 ${"{}"} \;
    '';

  };

  systemd.services.overseerr = {
    description = "Overseerr";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
    requires = [ "docker.service" "docker.socket" ];
    script = ''
      exec ${pkgs.docker}/bin/docker run \
          --rm \
          --name=overseerr \
          -e TZ=America/Chicago \
          --network=host \
          -v /root/appdata_config:/app/config \
          sctx/overseerr
    '';
    preStop = "${pkgs.docker}/bin/docker stop overseerr";
    reload = "${pkgs.docker}/bin/docker restart overseerr";
    serviceConfig = {
      ExecStartPre = "-${pkgs.docker}/bin/docker rm -f overseerr";
      ExecStopPost = "-${pkgs.docker}/bin/docker rm -f overseerr";
      TimeoutStartSec = 0;
      TimeoutStopSec = 120;
      Restart = "always";
    };
  };


  ## Need to apply this systemd service to see if it works
  ## Need to create a nixos service and configuration file for overseerr.
  ### Create a service and expose some options like sab, sonarr, radarr hosts

  environment.etc = {
    cloudflared_config = {
      text = ''
        tunnel: 665e68ba-83f2-4c63-8cd6-a41efb948ae1 
        credentials-file: ${config.sops.secrets.cloudflare_tunnel_overseerr_credentials.path}
        ingress:
          - hostname: requests.nickwilburn.com
            service: http://localhost:5055
          - service: http_status:404
      '';
    };
  };

  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };

  systemd.services.overseerr-tunnel = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate --config=/etc/cloudflared_config run";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };

  services.promtail = {
    configuration = {
      scrape_configs = [{
        job_name = "sabnzbd";
        static_configs = [{
          targets = [ "localhost" ];
          labels = {
            job = "sabnzbd";
            __path__ = "/var/lib/sabnzbd/logs/*";
          };
        }];
      }];
    };
    # extraFlags
  };
}
