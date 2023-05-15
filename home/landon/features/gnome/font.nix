{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Roboto Mono";
      #package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      package = pkgs.roboto-mono;
    };
    regular = {
      family = "Roboto Regular";
      package = pkgs.roboto;
    };
  };
}
