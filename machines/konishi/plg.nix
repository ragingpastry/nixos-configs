{ config, pkgs, ... }: {
  # grafana configuration

  # Configure TLS here. Will need secrets from ACME to be on the host
  # Reference config for konishi
  # nginx reverse proxy

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

    certs."nickwilburn.com" = {
      domain = "*.nickwilburn.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials_file.path;
      group = "nginx";
    };
  };

  services.nginx = {
    enable = true;
    defaultListenAddresses = [ "100.119.43.98" ];
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;


    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts = {

      "${config.services.grafana.settings.server.domain}" = {
        useACMEHost = "nickwilburn.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
      };

      "prometheus.nickwilburn.com" = {
        useACMEHost = "nickwilburn.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        };
      };

      "loki.nickwilburn.com" = {
        useACMEHost = "nickwilburn.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        };
      };

      "promtail.nickwilburn.com" = {
        useACMEHost = "nickwilburn.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}";
        };
      };
    };

  };

  services.prometheus = {
    port = 3020;
    enable = true;

    exporters = {
      node = {
        port = 3021;
        enabledCollectors = [ "systemd" ];
        enable = true;
      };
    };

    # ingest the published nodes
    scrapeConfigs = [{
      job_name = "nodes";
      static_configs = [{
        targets = [
          "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          "konishi:9002"
          "conjoiner:9003"
          "conjoiner:9002"
          "conjoiner:9707"
          "conjoiner:9708"
          "conjoiner:9709"
          "conjoiner:9710"
          "conjoiner:9711"
          "conjoiner:9712"
        ];
      }];
    }];
  };

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3030;
      auth_enabled = false;
      common = {
        ring = {
          instance_interface_names = [ "tailscale0" ];
        };
      };
      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [{
          from = "2022-06-06";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      chunk_store_config = {
        max_look_back_period = "0s";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };

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
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
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

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.nickwilburn.com";
        http_port = 3010;
        http_addr = "127.0.0.1";
        protocol = "http";
      };
      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };
    };
  };

}

