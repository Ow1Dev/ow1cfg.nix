{moduleWithSystem, ...}: {
  flake.nixosModules.network = moduleWithSystem ({...}: {...}: {
    networking = {
      networkmanager = {
        enable = true;
      };
    };
  });
}
