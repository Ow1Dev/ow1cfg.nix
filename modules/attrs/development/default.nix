{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.development = moduleWithSystem ({...}: let
    modules = with self.nixosModules; [
      nvim
      git
      pi-agent
    ];
  in {
    imports = modules;
  });
}
