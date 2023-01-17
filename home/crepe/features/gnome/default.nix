{ inputs, outputs, lib, config, osConfig, pkgs, ... }:
let
  wallpaper = builtins.fetchurl {
    url = "https://apod.nasa.gov/apod/image/2212/Makemakemoon100mile2000px.jpg";
    sha256 = "1vp89lcwsgk6mj98vzbaw7l8v76f4njf3gzaq2dqh7rxdabhv6lr";
  };
in
{

  imports = [
    ./font.nix
  ];

  home = {

    packages = with pkgs;
      [
        firefox
        google-chrome
        spotify
        discord
        sonixd
        zsh
        gnomeExtensions.dash-to-panel
        gnomeExtensions.dash-to-dock
        gnome.gnome-tweaks
      ] ++ lib.optional osConfig.services.tailscale.enable
        gnomeExtensions.tailscale-status;

  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "dash-to-panel@jderose9.github.com" ]
        ++ lib.optional osConfig.services.tailscale.enable
        "tailscale-status@maxgallup.github.com";
    };
    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      monospace-font-name = config.fontProfiles.monospace.family;
    };
    "org/gnome/desktop/background" = { picture-uri = wallpaper; };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "launch terminal";
      binding = "<Super>Return";
      command = "kgx";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = config.fontProfiles.regular.family;
      size = 12;
    };
  };

}
