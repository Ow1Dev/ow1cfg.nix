{...}: {
  imports = [
    ./desktop
    ./terminal
    ./software
  ];

  home.username = "ow1";
  home.homeDirectory = "/home/ow1";

  home.shellAliases = {
    vim = "nvim";
    vi = "nvim";
  };

  home.stateVersion = "25.05";
}
