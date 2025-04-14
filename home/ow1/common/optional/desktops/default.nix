{ pkgs, ... }:
{
  imports = [
    # Packages with custom configs go here

    ./niri
    ./anyrun

    ########## Utilities ##########
    # ./services/dunst.nix # Notification daemon
    ./waybar # infobar
    ./rofi.nix # app launcher
    #./fonts.nix
    #./playerctl.nix # cli util and lib for controlling media players that implement MPRIS
    #./gtk.nix # mainly in gnome
    #./qt.nix # mainly in kde
  ];
  home.packages = [
    pkgs.pavucontrol # gui for pulseaudio server and volume controls
    pkgs.wl-clipboard # wayland copy and paste
    pkgs.galculator # gtk based calculator
  ];
}
