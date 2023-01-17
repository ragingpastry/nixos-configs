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

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = "firefox/desktop";
    };
    defaultApplications = {
      "text/html" = "firefox/desktop";
      "x-scheme-handler/http" = "firefox/desktop";
      "x-scheme-handler/https" = "firefox/desktop";
      "x-scheme-handler/about" = "firefox/desktop";
      "x-scheme-handler/unknown" = "firefox/desktop";
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "dash-to-panel@jderose9.github.com" ]
        ++ lib.optional osConfig.services.tailscale.enable
        "tailscale-status@maxgallup.github.com";
      favorite-apps = [ "org.gnome.Nautilus.desktop" "discord.desktop" "spotify.desktop" "code.desktop" "org.gnome.Console.desktop" "firefox.desktop" ];
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
