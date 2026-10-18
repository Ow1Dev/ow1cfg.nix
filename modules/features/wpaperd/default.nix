{
  moduleWithSystem,
  inputs,
  ...
}: {
  flake.nixosModules.wpaperd = moduleWithSystem ({self', ...}: {
    environment.systemPackages = with self'.packages; [
      wpaperd
    ];
  });
  perSystem = {pkgs, ...}: {
    packages.wpaperd = let
      config-file = builtins.toFile "config.toml" ''
        [any]
        path = "${./wallpapers}"
      '';
    in
      inputs.wrappers.lib.wrapPackage ({...}: {
        inherit pkgs;
        package = pkgs.wpaperd;
        flags = {
          "--config" = config-file;
        };
      });
  };
}
