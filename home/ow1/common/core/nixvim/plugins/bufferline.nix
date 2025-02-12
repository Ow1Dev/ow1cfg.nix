{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.bufferline.enable = lib.mkEnableOption "enables bufferline module";
  };

  config = lib.mkIf config.nixvim-config.plugins.bufferline.enable {
    programs.nixvim = {
      plugins = {
        bufdelete.enable = true; # Replacement for bdelete that keeps windows intact
        bufferline = {
          enable = true;

          settings.options = {
            buffer_close_icon = null;
            close_icon = null;
            always_show_bufferline = false;
            separator_style = "slant";
            diagnostics = "nvim_lsp";
            offsets = [
              { filetype = "NvimTree"; }
              { text = "File Explorer"; }
              { highlight = "Directory"; }
              { separator = true; }
            ];
          };
        };
      };
      keymaps = [
        {
          key = "<leader>x";
          action = ":Bdelete <CR>";
          mode = "n";
          options = {
            silent = true;
            desc = "Delete buffer";
          };
        }
      ];
    };
  };
}
