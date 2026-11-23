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
          email = "31339803+Ow1Dev@users.noreply.github.com";
          name = "ow1dev";
        };
      };
    };
  };
}
