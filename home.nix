{ config, pkgs, inputs, ... }: {
  imports = [
    ./home/desktop/niri
  ];

  home.username = "ow1";
  home.homeDirectory = "/home/ow1";

  home.stateVersion = "25.05";

  programs.bash.enable = true;
  programs.bash.shellAliases.btw = "echo I use nixos, btw";

  programs.git = {
    enable = true;
    userName = "Ow1Dev";
    userEmail = "31339803+Ow1Dev@users.noreply.github.com";
  };
}
