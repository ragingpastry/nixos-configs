{ config, pkgs, ... }: {
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [{
        url = "https://loki.nickwilburn.com./loki/api/v1/push";
      }];
      scrape_configs = [{
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            job = "systemd-journal";
            host = "${config.networking.hostName}";
          };
        };
        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }];
      }];
    };
    # extraFlags
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "lnstat" ];
        port = 9002;
      };
      systemd = {
        enable = true;
        extraFlags = [ "--systemd.collector.enable-ip-accounting" ];
        port = 9003;
      };
    };
  };

  networking.firewall = {
    enable = true;
    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 9002 9003 ];
      };
    };
  };

}
