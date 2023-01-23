{ pkgs, ... }: {
  imports = [ ./git.nix ];

  home.packages = with pkgs; [ jq vim glab awscli fzf ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      # Doesn't show full directory path or hostname
      #theme = "robbyrussell";
      # Seems ok maybe...
      #theme = "afowler";
      # Boring old theme I alawys use
      #theme = "af-magic";
      # This is really good but it puts a wierd colored bar on the first line
      #theme = "blinks";
      theme = "bira";
      # New fav
      #theme = "mortalscumbag";
      #theme = "re5et";
    };
    initExtraBeforeCompInit = ''
      function vpn () {
        if [[ "$1" == "up" ]]; then
          sudo ${pkgs.tailscale}/bin/tailscale up --exit-node=konishi --reset;
        elif [[ "$1" == "down" ]]; then
          sudo ${pkgs.tailscale}/bin/tailscale up --exit-node= --reset;
        fi;
      }
    '';
  };
}
