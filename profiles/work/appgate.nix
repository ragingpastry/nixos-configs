{ pkgs, config, ... }: {

  #environment.systemPackages = with pkgs; [
  #  (appgate-sdp.override { nss = nss_latest; })
  #];

  nixpkgs.config.packageOverrides = pkgs: {
    appgate-sdp = (pkgs.appgate-sdp.override { nss = pkgs.nss_latest; });
  };

  programs.appgate-sdp.enable = true;

}

