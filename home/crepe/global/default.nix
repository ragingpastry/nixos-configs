{ inputs, lib, pkgs, config, outputs, ... }:
{
    imports = [
        ../features/cli
    ];

    nixpkgs = {
        config = {
            allowUnfree = true;
        };
    };

    nix = {
        package = lib.mkDefault pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" "repl-flake" ];
            warn-dirty = false;
        };
    };

    programs = {
        home-manager.enable = true;
        git.enable = true;
    };

    home = {
        username = lib.mkDefault "crepe";
        homeDirectory = lib.mkDefault "/home/${config.home.username}";
        stateVersion = lib.mkDefault "22.05";
    };
}