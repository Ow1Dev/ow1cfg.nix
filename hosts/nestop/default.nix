{
  imports = [
    ./hardware-configuration.nix
    ./../../systems
  ];

  programs.firefox.enable = true;
  programs.localsend.enable = true;

  networking.hostName = "nestop"; # Define your hostname.
}
