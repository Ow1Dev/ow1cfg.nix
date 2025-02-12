{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.neogit.enable = lib.mkEnableOption "enables neogit module";
  };

  config = lib.mkIf config.nixvim-config.plugins.neogit.enable {
    programs.nixvim = {
      plugins = {
        neogit = {
          enable = true;
          settings = {
            autoRefresh = true;
            disable_builtin_notifications = true;
            useMagitKeybindings = false;

            kind = "tab";
            commitPopup.kind = "split";
            popup.kind = "split";

            signs = {
              section = [
                ""
                ""
              ];
              item = [
                ""
                ""
              ];
              hunk = [
                ""
                ""
              ];
            };
          };
        };
      };

      keymaps = [
        {
          key = "<leader>gg";
          action = "<cmd>Neogit<CR>";
          mode = "n";
          options = {
            silent = true;
            desc = "Neogit";
          };
        }
      ];
    };
  };
}
