{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.web-devicons.enable = lib.mkEnableOption "enables web-devicons module";
  };

  config = lib.mkIf config.nixvim-config.plugins.web-devicons.enable {
    programs.nixvim.plugins = {
      web-devicons.enable = true;
    };
  };
}
