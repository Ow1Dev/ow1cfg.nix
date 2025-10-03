{
  config,
  pkgs,
  ...
}: {
  programs.niri = {
	enable = true;
        package = pkgs.niri;
	settings = {
		input.keyboard.xkb.layout = "dk";
			
      		screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
	};
  };
}
