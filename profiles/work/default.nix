{ ... }: {
  imports = [
    ./cac.nix
    ./appgate.nix
    ./awsvpnclient.nix
    ./vmware-client.nix
    ./zarf.nix
  ];
}
