{ pkgs, ... }:
{
    home.packages = with pkgs; [
        git
    ];

    programs.git = {
        enable = true;
        userName = "Nick Wilburn";
        userEmail = "senior.crepe@gmail.com";
    };
}