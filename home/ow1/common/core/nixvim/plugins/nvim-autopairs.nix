{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.nvim-autopairs.enable = lib.mkEnableOption "enables nvim-autopairs module";
  };

  config = lib.mkIf config.nixvim-config.plugins.nvim-autopairs.enable {
    programs.nixvim.plugins = {
      nvim-autopairs.enable = true;
    };
  };
}
