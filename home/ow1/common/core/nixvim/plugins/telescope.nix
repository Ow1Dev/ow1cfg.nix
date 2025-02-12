{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.telescope.enable = lib.mkEnableOption "enables telescope module";
  };

  config = lib.mkIf config.nixvim-config.plugins.telescope.enable {
    programs.nixvim.plugins = {
			telescope.enable = true;
    };
  };
}
