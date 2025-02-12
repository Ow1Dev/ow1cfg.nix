{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.lualine.enable = lib.mkEnableOption "enables lualine module";
  };

  config = lib.mkIf config.nixvim-config.plugins.lualine.enable {
    programs.nixvim = {
      plugins = {
        lualine = {
          enable = true;
          settings = {
            optionstheme = "horizon";
            settings.options.disabled_filetypes =
              let
                disabled = [
                  "NvimTree"
                  "NVimTree"
                  "NvimTree_1 "
                  "toggleterm"
                ];
              in
              {
                statusline = disabled;
                winbar = disabled;
              };
          };
        };
      };
    };
  };
}
