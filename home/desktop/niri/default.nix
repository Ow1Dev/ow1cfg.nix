{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Temporarily disable imports to isolate
  imports = [
    inputs.niri.homeModules.niri
    ./settings.nix
    ./binds.nix
    ./rules.nix
  ];

  home.packages = with pkgs; [seatd jaq];
}
