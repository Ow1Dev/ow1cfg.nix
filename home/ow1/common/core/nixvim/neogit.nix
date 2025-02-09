{
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
            section = [ "" "" ];
            item = [ "" "" ];
            hunk = [ "" "" ];
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
}
