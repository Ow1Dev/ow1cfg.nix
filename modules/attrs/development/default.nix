{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.development = moduleWithSystem ({pkgs, ...}: let
    modules = with self.nixosModules; [
      nvim
      git
      pi-agent
    ];
  in {
    imports = modules;
    environment.systemPackages = with pkgs; [
      devenv
    ];
  });
}
