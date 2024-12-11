{ config, lib, ... }:
{
  boot.loader.systemd-boot.configurationLimit = 10;
}
