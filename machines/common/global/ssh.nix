{ outputs, lib, config, ... }:
let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in
{
    services.openssh = {
        enable = true;
        passwordAuthentication = false;
        permitRootLogin = "no";
    };

    programs.ssh = {
        knownHosts = builtins.mapAttrs (name: _: {
            publicKeyFile = pubKey name;
            extraHostNames = lib.optional (name == hostname) "localhost";
        }) hosts;
    };

    security.pam.enableSSHAgentAuth = true;
}