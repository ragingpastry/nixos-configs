{ config, pkgs, lib, ... }:
{
  imports = [ ../modules/minecraft ];
  containers.minecraft-user = {
      autoStart = true;
      ephemeral = true;
      bindMounts.minecraft-user = {
        hostPath   = "/var/lib/minecraft/user";
        mountPoint = "/var/lib/minecraft-bedrock";
        isReadOnly = false;
      };
      config = { config, pkgs, ... }: {
        boot.isContainer = true;
        networking.hostName = "minecraft-user";
        imports = [ ../modules/minecraft ];
        systemd.coredump.enable = true;
        services.minecraft-bedrock-server = {
          enable = true;
          serverProperties = {
            server-name = "user's Minecraft Server";
            gamemode = "creative";
            difficulty = "easy";
            allow-cheats = true;
            white-list = true;
            server-port = 19134;
            server-portv6 = 19135;
          };
        };
      };
  };
}