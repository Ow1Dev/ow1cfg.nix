{ pkgs, ... }:
{
  imports = [
    # Packages with custom configs go here
    ./niri

    ########## Utilities ##########
    ./services/dunst.nix # Notification daemon
    ./waybar # infobar
    #./rofi # app launcher
    ./ghostty.nix # terminal
    ./hyprlock.nix # lock
    ./sherlock.nix # lock
    ./yazi.nix # lock
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
