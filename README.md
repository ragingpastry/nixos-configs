# My NixOS Configs

## Adding a new host
TODO: Get a `nix build #.<hostname>` to build a new kexec image I can SSH over
1. Install host
2. On remote host: `nix-shell -p ssh-to-age --run "ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub"`
3. On remote host: `nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key"`
4. Put both of these values in `~/.config/sops/age/keys.txt`
5. Add paths to .sops.yaml
6. Reencrypt `machines/common/secrets.yaml`