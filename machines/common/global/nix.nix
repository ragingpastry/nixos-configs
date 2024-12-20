{ pkgs, inputs, lib, config, ... }: {
  nix = {
    settings = {
      substituters =
        [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      fallback = true;

      max-jobs = "auto";
      warn-dirty = false;
      system-features = [ "kvm" "big-parallel" ];
    };
    package = pkgs.nixVersions.latest;
    #package = pkgs.nixVersions.nix_2_17;
    gc = {
      automatic = true;
      options = "-d";
      dates = "weekly";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registries to channels
    # Very useful when using legacy commands
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
  };
}
