{ config, pkgs, lib, ... }:
{
  boot.kernel.sysctl = { "net.ipv4.conf.all.forwarding" = lib.mkForce true; };
  services.tailscale.useRoutingFeatures = "both";

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to tailscale";

    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # Check if we are already an exit node
      exitNodeState="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .Self.ExitNode)"

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        if [ $exitNodeState = "false" ]; then
          authKey="$(cat ${config.sops.secrets.tailscaleAuthKey.path})"
          ${tailscale}/bin/tailscale up --advertise-exit-node --auth-key "$authKey" --operator crepe
        fi;
        exit 0
      fi

      authKey="$(cat ${config.sops.secrets.tailscaleAuthKey.path})"
      ${tailscale}/bin/tailscale up --advertise-exit-node --auth-key "$authKey" --operator crepe
    '';
  };

}
