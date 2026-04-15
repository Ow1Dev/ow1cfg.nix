{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.ow1top = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.ow1topConfiguration
    ];
  };
}
