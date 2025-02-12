{ lib, ... }: {
  imports = lib.custom.scanPaths ./.;

  #   config = lib.mkIf config.nixvim-config.enable {  # don't want to gif on options one level out of here yet
  config = {
    #
    # ========== ui ==========
    #
    nixvim-config.plugins.alpha.enable = lib.mkDefault true;
    nixvim-config.plugins.tmux-navigator.enable = lib.mkDefault true;

    #
    # ========== completion ==========
    #
    nixvim-config.plugins.cmp.enable = lib.mkDefault true;

    #
    # ========== lsp ==========
    #
    nixvim-config.plugins.fidget.enable = lib.mkDefault true;
    nixvim-config.plugins.lspconfig.enable = lib.mkDefault true;
  };
}
