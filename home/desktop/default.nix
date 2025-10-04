{pkgs, ...}: {
  imports = [
    ./niri
    ./terminal/ghostty.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    swww
    # utils
    wl-clipboard
  ];

  services.swww.enable = true;

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
