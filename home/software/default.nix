{pkgs, ...}: let
  spotify-wayland = pkgs.callPackage ../../pkgs/spotify.nix {};
in {
  imports = [
    ./browsers/chromium.nix
    ./webapps/notion.nix
  ];

  home.packages = [
    spotify-wayland
  ];
}
