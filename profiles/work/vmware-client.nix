{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    vmware-horizon-client
  ];
}

