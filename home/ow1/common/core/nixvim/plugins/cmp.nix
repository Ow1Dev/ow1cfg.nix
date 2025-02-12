{
  config,
  lib,
  ...
}:
{
  options = {
    nixvim-config.plugins.cmp.enable = lib.mkEnableOption "enables cmp and lspkind modules";
  };

  config = lib.mkIf config.nixvim-config.plugins.cmp.enable {
    programs.nixvim.plugins = {
      lspkind.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          window = {
            completion = {
              border = "rounded";
              scrollbar = false;
            };
            documentation = {
              border = "rounded";
            };
            snippet.expand =
              # lua
              ''
                function(args)
                  require("luasnip").lsp_expand(args.body)
                end
              '';
          };
          sources = [
            { name = "cmp-nvim-lsp"; }
            { name = "async_path"; }
            { name = "nvim_lsp_signature_help"; }
            {
              name = "nvim_lsp";
              keyword_length = 3;
            }
            {
              name = "nvim_lua";
              keyword_length = 2;
            }
            { name = "luasnip"; }
            {
              name = "buffer";
              keyword_length = 2;
            }
          ];

          mapping = {
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-f>" = "cmp.mapping.scroll_docs(1)";
            "<C-b>" = "cmp.mapping.scroll_docs(-1)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-Esc>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-buffer.enable = true;
      cmp-async-path.enable = true;
      cmp-cmdline.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;

      luasnip = {
        enable = true;
      };
    };
  };
}
