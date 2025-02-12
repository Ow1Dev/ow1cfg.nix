{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.colorizer.enable = lib.mkEnableOption "enables colorizer module";
  };

  config = lib.mkIf config.nixvim-config.plugins.colorizer.enable {
    programs.nixvim.plugins = {
      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
        settings.filetypes = [
          "css"
          "scss"
        ];
      };
    };
  };
}
