_: {
  # nh default flake
  environment.variables.NH_FLAKE = "/home/ow1/nixos-dotfiles";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };
}
