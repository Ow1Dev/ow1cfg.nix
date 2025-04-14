{
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    extraConfig = {
      show-icons = true;
      # icon-theme = "";
      # hover-select = true;
      drun-match-fields = "name";
      drun-display-format = "{name}";
    };

    theme = {
        "*" = {
          width = 500;
        };
    };
  };
}
