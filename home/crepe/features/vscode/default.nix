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
      golang.go
      dracula-theme.theme-dracula
      ms-vsliveshare.vsliveshare
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "ansible";
        publisher = "redhat";
        version = "1.1.34";
        sha256 = "UyAbQpe2KpoBZVk1AwfEr3BoLPwHxps284l0ZzjMQDE=";
      }
      {
        name = "hcl";
        publisher = "hashicorp";
        version = "0.3.2";
        sha256 = "cxF3knYY29PvT3rkRS8SGxMn9vzt56wwBXpk2PqO0mo=";
      }
      {
        name = "opa";
        publisher = "tsandall";
        version = "0.12.1";
        sha256 = "HoFX0pNTbL4etkmZVvezmL0vKE54QZtIPjcAp2/llqs=";
      }
    ];
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "editor.fontFamily" = "${config.fontProfiles.monospace.family}";
      "workbench.coloTheme" = "Monokai Dimmed";
    };
  };

}
