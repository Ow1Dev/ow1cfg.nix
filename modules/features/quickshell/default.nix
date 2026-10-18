{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.quickshell = moduleWithSystem (
    {self'}: {
      environment.systemPackages = with self'.packages; [
        quickshell
      ];

      # Battery segment in the bar
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
