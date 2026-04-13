{ self, inputs, ...}: {

  perSystem = { pkgs, ... }: {

    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      settings.config_directory = ./.;
    };
  };

}
