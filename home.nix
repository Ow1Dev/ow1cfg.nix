{ config, pkgs, ...}: {

	home.username="ow1";
	home.homeDirectory="/home/ow1";

	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use nixos, btw";
		};
	};

	programs.git = {
		enable = true;
		userName = "Ow1Dev";
		userEmail = "31339803+Ow1Dev@users.noreply.github.com";
	};


	home.stateVersion = "25.05";
}
