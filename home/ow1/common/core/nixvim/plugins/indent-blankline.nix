{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.indent-blankline.enable = lib.mkEnableOption "enables indent-blankline module";
  };

  config = lib.mkIf config.nixvim-config.plugins.indent-blankline.enable {
    programs.nixvim.plugins = {
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            show_end = false;
            show_exact_scope = true;
            show_start = false;
          };
        };
      };
    };
  };
}
