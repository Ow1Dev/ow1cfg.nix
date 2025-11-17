{pkgs, ...}: {
  imports = [
    ./obs.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pamixer
    alsa-utils
    easyeffects
  ];
}
