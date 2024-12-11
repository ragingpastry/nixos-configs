{ pkgs, ... }: {
  home.packages = with pkgs; [ git ];

  programs.git = {
    enable = true;
    userName = "Nick Wilburn";
    userEmail = "senior.crepe@gmail.com";
    includes = [
      {
        condition = "hasconfig:remote.*.url:https://gitlab.90cos.cdl.af.mil/**";
        contents = {
          user = {
            email = "nicholas.wilburn.1.ctr@us.af.mil";
            name = "Nicholas O Wilburn";
            signingKey = "0x9711E5F8";
          };
          gpg = {
            format = "x509";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };
}
