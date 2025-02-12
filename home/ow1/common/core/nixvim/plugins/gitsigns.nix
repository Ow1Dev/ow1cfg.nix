{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.gitsigns.enable = lib.mkEnableOption "enables gitsigns module";
  };

  config = lib.mkIf config.nixvim-config.plugins.gitsigns.enable {
    programs.nixvim.plugins = {
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
  };
}
