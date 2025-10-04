{ ... }: {
  imports = [
    ./desktop
    ./terminal
  ];

  home.username = "ow1";
  home.homeDirectory = "/home/ow1";

  home.shellAliases = {
    vim = "nvim";
    vi = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "Ow1Dev";
    userEmail = "31339803+Ow1Dev@users.noreply.github.com";
  };

  home.stateVersion = "25.05";
}
