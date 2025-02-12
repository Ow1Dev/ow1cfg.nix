{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.toggleterm.enable = lib.mkEnableOption "enables toggleterm module";
  };

  config = lib.mkIf config.nixvim-config.plugins.toggleterm.enable {
    programs.nixvim = {
      plugins = {
        toggleterm = {
          enable = true;
          settings.float_opts.border = "curved";
        };
      };

      keymaps = [
        # Terminal
        {
          key = "<C-x>";
          action = "<C-\\><C-N>";
          mode = "t";
          options.desc = "Exit terminal";
        }

        {
          key = "<Leader>fw";
          action = "<cmd> ToggleTerm direction=float <CR>";
          mode = "n";
          options = {
            silent = true;
            desc = "Floating terminal";
          };
        }
      ];
    };
  };
}
