{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.exportarr;
  enable_opt = mkOption {
    type = types.bool;
    default = false;
    description = ''
      If enabled, NixOS will run exportarr with the configured service.
    '';
  };
  api_key_opt = mkOption {
    type = types.str;
    default = "";
    description = ''
      The API key to use.
    '';
  };
  api_key_file_opt = mkOption {
    type = types.nullOr types.path;
    default = null;
    description = ''
      The file containing the API key to use.
    '';
  };
  config_opt = mkOption {
    type = types.path;
    default = null;
    description = ''
      Path to the config.xml file for parsing authentication information.
    '';
  };

  additional_metrics_opt = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Enable additional metric collection (more resource intensive).
    '';
  };

  listen_interface_opt = mkOption {
    type = types.str;
    default = "";
    description = ''
      The interface that exportarr will listen on.
    '';
  };
in
{
  options.services.exportarr.lidarr = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:8686";
      description = ''
        The URL of the lidarr instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9709";
      description = ''
        The port that exportarr will listen on and export metrics for Lidarr.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  options.services.exportarr.readarr = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:9797";
      description = ''
        The URL of the Readarr instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9711";
      description = ''
        The port that exportarr will listen on and export metrics for Readarr.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  options.services.exportarr.radarr = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:7878";
      description = ''
        The URL of the Radarr instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9708";
      description = ''
        The port that exportarr will listen on and export metrics for Radarr.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  options.services.exportarr.sonarr = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:8989";
      description = ''
        The URL of the Radarr instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9707";
      description = ''
        The port that exportarr will listen on and export metrics for Sonarr.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  options.services.exportarr.prowlarr = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:9696";
      description = ''
        The URL of the Radarr instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9710";
      description = ''
        The port that exportarr will listen on and export metrics for Prowlarr.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  options.services.exportarr.sabnzbd = {
    enable = enable_opt;
    api_key = api_key_opt;
    api_key_file = api_key_file_opt;
    config = config_opt;
    additionalMetrics = additional_metrics_opt;
    url = mkOption {
      type = types.str;
      default = "http://localhost:8080";
      description = ''
        The URL of the Sabnzbd instance.
      '';
    };
    listen_port = mkOption {
      type = types.str;
      default = "9712";
      description = ''
        The port that exportarr will listen on and export metrics for Sabnzbd.
      '';
    };
    listen_interface = listen_interface_opt;
  };

  imports = [
    ./lidarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./readarr.nix
    ./prowlarr.nix
    ./sabnzbd.nix
  ];

}
