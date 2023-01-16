{ pkgs, ... }: {
  imports = [ ./git.nix ];

  home.packages = with pkgs; [ jq vim ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
