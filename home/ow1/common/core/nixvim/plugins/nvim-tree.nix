{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.nvim-tree.enable = lib.mkEnableOption "enables nvim-tree module";
  };

  config = lib.mkIf config.nixvim-config.plugins.nvim-tree.enable {
    programs.nixvim.plugins = {
      nvim-tree = {
        enable = true;
        git = {
          enable = true;
          ignore = false;
        };
        renderer = {
          highlightGit = true;
          rootFolderLabel = false;
          indentMarkers = {
            enable = true;
            icons = {
              bottom = "─";
              edge = "│";
              corner = "╰";
            };
          };
          icons = {
            glyphs = {
              default = "󰈚 ";
              folder = {
                default = " ";
                empty = " ";
                emptyOpen = " ";
                open = " ";
                symlink = " ";
              };
              git = {
                unmerged = "";
              };
            };
          };
        };
        view.side = "right";
        hijackCursor = true;
      };
    };
  };
}
