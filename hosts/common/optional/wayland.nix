{ pkgs, ... }:
{
  # general packages related to wayland
  environment.systemPackages = [
    pkgs.swww # backend wallpaper daemon required by waypaper
  ];
}
