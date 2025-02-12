# LSP Progress Indicator
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.tmux-navigator.enable = lib.mkEnableOption "enables tmux-navigator module";
  };

  config = lib.mkIf config.nixvim-config.plugins.tmux-navigator.enable {
    programs.nixvim.plugins = {
      tmux-navigator = {
        enable = true;
        keymaps = [
          {
            action = "left";
            key = "<C-h>";
          }
          {
            action = "down";
            key = "<C-j>";
          }
          {
            action = "up";
            key = "<C-k>";
          }
          {
            action = "right";
            key = "<C-l>";
          }
        ];
      };
    };
  };
}
