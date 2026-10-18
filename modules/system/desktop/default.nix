{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.desktop = moduleWithSystem ({...}: let
    modules = with self.nixosModules; [core mangowm sddm foot network quickshell];
  in {
    imports = modules;
  });
}
