{moduleWithSystem, ...}: {
  flake.nixosModules.localsend = moduleWithSystem ({...}: {
    programs.localsend.enable = true;
  });
}
