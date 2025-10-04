{ pkgs, ...}: {
  imports = [
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
  ];
}
