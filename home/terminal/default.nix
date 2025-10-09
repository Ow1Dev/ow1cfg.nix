{
  inputs,
  ...
}: {
  imports = [
    ./shell/starship.nix
    ./shell/nushell.nix

    ./software

    inputs.ow1nvim.homeManagerModules.default
  ];

  programs.neovim-flake.enable = true;
}
