{ pkgs, config, lib, outputs, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  programs.zsh.enable = true;
  users.users.crepe = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2NZGps677tIn3/VkUphA7fGxUMwyPh9BjSNVgRTEy/ polis"
    ];
    passwordFile = config.sops.secrets.crepe-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.crepe-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.crepe = import home/${config.networking.hostName}.nix;

}
