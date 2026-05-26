{ self, pkgs, ... }: {
  home.packages = [
    self.inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
