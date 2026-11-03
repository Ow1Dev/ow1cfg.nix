{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.pi-agent = moduleWithSystem ({
    self',
    pkgs,
    ...
  }: {
    environment.systemPackages = [
      self'.packages.pi-agent
      pkgs.ripgrep
    ];
  });
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      pi-agent = inputs.wrappers.lib.wrapPackage ({...}: {
        inherit pkgs;
        package = inputs'.pidev.packages.default;
      });
    };
  };
}
