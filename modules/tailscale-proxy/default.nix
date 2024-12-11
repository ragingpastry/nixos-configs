{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.tailscale-proxy;

in
{
  options.services.tailscale-proxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, NixOS will run exportarr with the configured service.
      '';
    };
    proxyPort = mkOption {
      type = types.str;
      default = "1055";
      description = ''
        The port that exportarr will listen on and export metrics for Lidarr.
      '';
    };
    environmentFile = mkOption {
      type = types.str;
      description = ''
        The environmentFile to use for the systemd service.
        This can be used for passing the TS_AUTHKEY.
      '';
    };
    exitNodeIP = mkOption {
      type = types.str;
      description = ''
        The URL of the lidarr instance.
      '';
    };
    listenIP = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The IP address to listen on.
      '';
    };
    dockerImage = mkOption {
      type = types.str;
      default = "tailscale/tailscale:latest";
      description = ''
        The Docker image to use.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.tailscale-proxy = {
      description = "Tailscale HTTP/SOCKS Proxy running in Docker";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        TimeoutStopSec = 70;
        RemainAfterExit = "true";
        Type = "oneshot";
        ExecStartPre = "-${pkgs.docker}/bin/docker rm -f %n";
        ExecStart = ''
          ${pkgs.docker}/bin/docker run -p ${cfg.listenIP}:${cfg.proxyPort}:1055 --expose ${cfg.proxyPort} \
            -d --name %n \
            -e TS_AUTHKEY \
            -e TS_OUTBOUND_HTTP_PROXY_LISTEN=:1055 \
            -e TS_SOCKS5_SERVER=:1055 \
            -e TS_EXTRA_ARGS=--exit-node=${cfg.exitNodeIP} \
            ${cfg.dockerImage}
        '';
        ExecStop = "${pkgs.docker}/bin/docker rm -f %n";
        EnvironmentFile = "${cfg.environmentFile}";
      };
    };
  };
}
