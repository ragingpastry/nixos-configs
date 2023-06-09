{ config, pkgs, lib, ... }: {
  sops.secrets.tailscaleAuthKey = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to tailscale";

    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      authKey="$(cat ${config.sops.secrets.tailscaleAuthKey.path})"

      ${tailscale}/bin/tailscale up -authkey "$authKey"
    '';
  };
}
