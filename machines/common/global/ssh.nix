{ outputs, lib, config, ... }:
let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh = {
    knownHosts = builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = lib.optional (name == hostname) "localhost";
      })
      hosts;
  };

  #security.pam.enableSSHAgentAuth = true;

  services.openssh.ports = [ 22 50022 ];
  services.openssh.openFirewall = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 50022 ];
    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 22 ];
      };
    };
  };
}
