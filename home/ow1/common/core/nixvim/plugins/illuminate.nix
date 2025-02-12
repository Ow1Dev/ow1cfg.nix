{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.illuminate.enable = lib.mkEnableOption "enables illuminate module";
  };

  config = lib.mkIf config.nixvim-config.plugins.illuminate.enable {
    programs.nixvim.plugins = {
      illuminate = {
        enable = true; # Used to illuminate same words
        filetypesDenylist = [
          "adoc"
          "asciidoc"
          "dirvish"
          "fugitive"
          "nvimtree"
          "nvim-tree"
          "NvimTree"
        ];
      };
    };
  };
}
