{ ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>h";
        action = ":noh<CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Clear search";
        };
      }

      # Line numbers
      {
        key = "<leader>n";
        action = "<cmd> set nu! <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Toggle line number";
        };
      }

      {
        key = "<leader>rn";
        action = "<cmd> set rnu! <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Toggle relative line number";
        };
      }

      # buffer tabs
      {
        key = "<leader>b";
        action = "<cmd> enew <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "New buffer";
        };
      }

      {
        key = "<tab>";
        action = "<cmd> BufferLineCycleNext <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Next buffer";
        };
      }

      {
        key = "<S-tab>";
        action = "<cmd> BufferLineCyclePrev <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Previous buffer";
        };
      }
      {
        key = "<leader>tp";
        action = "<cmd> BufferLineTogglePin <CR>";
        mode = "n";
        options = {
          silent = true;
          desc = "Pin buffer";
        };
      }

      {
        key = "<Leader>te";
        action = "<cmd> TodoQuickFix <CR>";
        mode = "n";
        options.desc = "TODO summary";
      }

      {
        key = "<Leader>tc";
        action = "<cmd> TodoTelescope <CR>";
        mode = "n";
        options.desc = "TODO telescope";
      }
    ];

    plugins.which-key = {
      settings.spec = [
        {
          __unkeyed-1 = "<Leader>gD";
          desc = "Goto reference";
        }

        {
          __unkeyed-1 = "<Leader>gd";
          desc = "Goto definition";
        }

        {
          __unkeyed-1 = "<Leader>g";
          desc = "Git options";
        }

        {
          __unkeyed-1 = "<Leader>gs";
          desc = "Git stage options";
        }

        {
          __unkeyed-1 = "<Leader>gc";
          desc = "Comment lines";
        }
        {
          __unkeyed-1 = "<Leader>gcc";
          desc = "Comment line";
        }
      ];
    };
  };
}
