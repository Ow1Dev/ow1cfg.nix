{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.pi-agent = moduleWithSystem ({self', ...}: {
    environment.systemPackages = with self'.packages; [
      pi-agent
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
