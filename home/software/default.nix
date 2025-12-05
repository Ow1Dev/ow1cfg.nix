{pkgs, ...}: let
  spotify-wayland = pkgs.callPackage ../../pkgs/spotify.nix {};
in {
  imports = [
    ./browsers/chromium.nix
    ./webapps/notion.nix
    ./media
  ];

  home.packages = [
    spotify-wayland
    pkgs.looking-glass-client
  ];
}
