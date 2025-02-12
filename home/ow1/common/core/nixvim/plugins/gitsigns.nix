{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.gitsigns.enable = lib.mkEnableOption "enables gitsigns module";
  };

  config = lib.mkIf config.nixvim-config.plugins.gitsigns.enable {
    programs.nixvim = {
      plugins = {
        gitsigns = {
          enable = true;
          settings.signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "│";
            topdelete.text = "󰍵";
            changedelete.text = "~";
            untracked.text = "│";
          };
        };
      };
      keymaps = [
        # Git
        {
          key = "<Leader>gsr";
          action = ":Gitsigns reset_hunk <CR>";
          mode = "n";
          options.desc = "Reset hunk";
        }

        {
          key = "<Leader>gsh";
          action = ":Gitsigns stage_hunk <CR>";
          mode = "n";
          options.desc = "Stage hunk";
        }

        {
          key = "<Leader>gsu";
          action = ":Gitsigns undo_stage_hunk <CR>";
          mode = "n";
          options.desc = "Undo stage hunk";
        }

        {
          key = "<Leader>gh";
          action = ":Gitsigns preview_hunk <CR>";
          mode = "n";
          options.desc = "Preview hunk";
        }

        {
          key = "<Leader>gb";
          action = ":Gitsigns blame_line<CR>";
          mode = "n";
          options.desc = "Git blame";
        }
      ];
    };
  };
}
