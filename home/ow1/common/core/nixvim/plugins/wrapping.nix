{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.wrapping.enable = lib.mkEnableOption "enables wrapping module";
  };

  config = lib.mkIf config.nixvim-config.plugins.wrapping.enable {
    programs.nixvim.plugins = {
      wrapping.enable = true;
    };
  };
}
