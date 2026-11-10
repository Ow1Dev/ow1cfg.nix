{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.noctalia = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.noctalia];

    hardware.bluetooth.enable = true;
    services.upower.enable = true;
    services.tuned.enable = true;
    networking.networkmanager.enable = true;
  });
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.noctalia = inputs.wrappers.wrappers.noctalia.wrap {
      inherit pkgs;
    };
  };
}
