{ pkgs ? import <nixpkgs> { }
}: {
  dod-certs = pkgs.callPackage ./dod-certs.nix { };
}
