{ pkgs, ... }: {
  imports = [ ./git.nix ];

  home.packages = with pkgs; [ jq vim glab awscli fzf devbox direnv nixwarp kubectl fluxcd ];

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
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
      function bastion() {
        glab ci run --repo https://gitlab.90cos.cdl.af.mil/90cos/cmn/iac/infra/windows-bastion.git --branch master --variables DEPLOYMENT:$1
      }
      function vpn () {
        if [[ "$1" == "up" ]]; then
          sudo ${pkgs.tailscale}/bin/tailscale up --exit-node=konishi --reset;
        elif [[ "$1" == "down" ]]; then
          sudo ${pkgs.tailscale}/bin/tailscale up --exit-node= --reset;
        fi;
      }
      function beegfiles() {
        git rev-list --objects --all |
        git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
        sed -n 's/^blob //p' |
        sort --numeric-sort --key=2 |
        cut -c 1-12,41- |
        $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
      }
      export EDITOR=$(which vim)
      eval "$(direnv hook zsh)"
    '';
  };
}
