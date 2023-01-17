{ pkgs, config, ... }: {
  home.packages = with pkgs;
    [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions;
          [ vscodevim.vim hashicorp.terraform ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "ansible";
              publisher = "redhat";
              version = "1.1.34";
              sha256 = "UyAbQpe2KpoBZVk1AwfEr3BoLPwHxps284l0ZzjMQDE=";
            }
            {
              name = "Nix";
              publisher = "bbenoist";
              version = "1.0.1";
              sha256 = "qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
            }
          ];
      })
    ];
}
