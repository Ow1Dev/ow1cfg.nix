{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.quickshell = moduleWithSystem (
    {self', pkgs, ...}: {
      environment.systemPackages = with self'.packages; [
        quickshell
        pkgs.swaylock
      ];

      # Battery segment in the bar
      services.upower.enable = true;
      security.pam.services.swaylock = {};
    }
  );
  perSystem = {pkgs, ...}: {
    packages.quickshell = inputs.wrappers.wrappers.quickshell.wrap {
      inherit pkgs;

      configDir = ./.;
    };
  };
}
