{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.git = {pkgs, ...}: {
    programs.git = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
    };
  };
  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrappers.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
          email = "ow1@ow1.dev";
          name = "ow1dev";
        };
      };
    };
  };
}
