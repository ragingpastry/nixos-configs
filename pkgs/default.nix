{ pkgs ? import <nixpkgs> { } }:
{
  zarf = pkgs.callPackage ./zarf { };
  devbox = pkgs.callPackage ./devbox { };
  dod-certs = pkgs.callPackage ./dod-certs { };
  exportarr = pkgs.callPackage ./exportarr { };
  nixwarp = pkgs.callPackage ./nixwarp { };
  sonarr-search-missing = pkgs.callPackage ./sonarr-search-missing { };
}
