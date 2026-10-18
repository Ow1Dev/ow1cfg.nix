{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.Ow1Top = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      desktop
      ow1topConfiguration
      development
    ];
  };
}
