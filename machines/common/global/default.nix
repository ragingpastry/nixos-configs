# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./nix.nix
    ./ssh.nix
    ./sops.nix
    ./tailscale.nix
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays ++ [ inputs.awsvpnclient.overlay ];
    config = { allowUnfree = true; };
  };

  programs.fuse.userAllowOther = true;
  hardware.enableRedistributableFirmware = true;

  security.sudo.wheelNeedsPassword = false;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
