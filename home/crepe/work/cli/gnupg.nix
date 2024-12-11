{ pkgs, ... }: {
  home.packages = with pkgs; [ gnupg ];

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      reader-port = "046A:00A1:X:0";
      pcsc-driver = "${pkgs.pcsclite.lib}/lib/libpcsclite.so";
    };
  };
}
