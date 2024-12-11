{ pkgs, ... }: {
  imports = [ ./git.nix ./gnupg.nix ];

  home.packages = with pkgs; [ slack gnupg dig pinentry ];

  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = ''
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
      git="TZ=UTC git"
      export EDITOR=$(which vim)
      eval "$(direnv hook zsh)"
    '';
  };
}
