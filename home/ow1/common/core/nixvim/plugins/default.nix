{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;

  #   config = lib.mkIf config.nixvim-config.enable {  # don't want to gif on options one level out of here yet
  config = {
    #
    # ========== ui ==========
    #
    nixvim-config.plugins.alpha.enable = lib.mkDefault true;
    nixvim-config.plugins.colorizer.enable = lib.mkDefault true;
    nixvim-config.plugins.illuminate.enable = lib.mkDefault true;
    nixvim-config.plugins.indent-blankline.enable = lib.mkDefault true;
    nixvim-config.plugins.web-devicons.enable = lib.mkDefault true;

    #
    # ========== bars/lines ==========
    #
    nixvim-config.plugins.bufferline.enable = lib.mkDefault false;
    nixvim-config.plugins.lualine.enable = lib.mkDefault true;

    #
    # ========== completion ==========
    #
    nixvim-config.plugins.cmp.enable = lib.mkDefault true;
    nixvim-config.plugins.nvim-autopairs.enable = lib.mkDefault true;

    #
    # ========== languages ==========
    #
    nixvim-config.plugins.treesitter.enable = lib.mkDefault true;

    #
    # ========== Git ==========
    #
    nixvim-config.plugins.neogit.enable = lib.mkDefault true;
    nixvim-config.plugins.gitsigns.enable = lib.mkDefault true;

    #
    # ========== Tree ==========
    #
    nixvim-config.plugins.nvim-tree.enable = lib.mkDefault true;

    #
    # ========== lsp ==========
    #
    nixvim-config.plugins.fidget.enable = lib.mkDefault true;
    nixvim-config.plugins.lspconfig.enable = lib.mkDefault true;

    #
    # ========== search ==========
    #
    nixvim-config.plugins.telescope.enable = lib.mkDefault true;

    #
    # ========== utils ==========
    #
    nixvim-config.plugins.which-key.enable = lib.mkDefault true;
    nixvim-config.plugins.toggleterm.enable = lib.mkDefault true;
    nixvim-config.plugins.tmux-navigator.enable = lib.mkDefault true;
    nixvim-config.plugins.wrapping.enable = lib.mkDefault true;
  };
}
