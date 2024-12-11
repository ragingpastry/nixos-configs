{ inputs, pkgs, ... }: {
  imports = [ ./global ./features/gnome ./features/vscode ./work/cli ];

}
