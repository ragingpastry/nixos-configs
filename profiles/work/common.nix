{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    zarf
  ];
}
