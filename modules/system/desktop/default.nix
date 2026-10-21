{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.desktop = moduleWithSystem ({...}: let
    modules = with self.nixosModules; [core mangowm sddm foot network quickshell hyprlock hypridle];
  in {
    imports = modules;

    # System defaults; a browser chosen in the user's settings takes precedence.
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  });
}
