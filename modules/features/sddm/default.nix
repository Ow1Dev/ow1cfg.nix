{...}: {
  flake.nixosModules.sddm = {...}: {
    services.displayManager.sddm.enable = true;
  };
}
