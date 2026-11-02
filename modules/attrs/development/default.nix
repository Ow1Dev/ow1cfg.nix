{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.development = moduleWithSystem ({unstablePkgs, ...}: let
    modules = with self.nixosModules; [
      nvim
      git
      pi-agent
    ];
  in {
    imports = modules;
    environment.systemPackages = with unstablePkgs; [
      devenv
    ];
  });
}
