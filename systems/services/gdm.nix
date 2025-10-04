{
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;
  };

  programs.niri.enable = true;
}
