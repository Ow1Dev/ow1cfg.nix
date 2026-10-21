{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.quickshell = moduleWithSystem (
    {self', ...}: {
      environment.systemPackages = [self'.packages.quickshell];
      services.upower.enable = true;
    }
  );
  perSystem = {pkgs, ...}: {
    packages.quickshell = inputs.wrappers.wrappers.quickshell.wrap {
      inherit pkgs;
      configDir = ./.;
    };
  };
}
