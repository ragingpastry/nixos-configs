{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix
      hashicorp.terraform
      dracula-theme.theme-dracula
      ms-vsliveshare.vsliveshare
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "ansible";
        publisher = "redhat";
        version = "1.1.34";
        sha256 = "UyAbQpe2KpoBZVk1AwfEr3BoLPwHxps284l0ZzjMQDE=";
      }
    ];
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "editor.fontFamily" = "${config.fontProfiles.monospace.family}";
      "workbench.coloTheme" = "Monokai Dimmed";
    };
  };

}
