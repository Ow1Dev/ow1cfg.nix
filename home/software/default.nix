{ pkgs, ...}: 
let
 spotify-wayland = pkgs.callPackage ../../pkgs/spotify.nix { };
in {
  home.packages = [
     spotify-wayland
  ];
}
