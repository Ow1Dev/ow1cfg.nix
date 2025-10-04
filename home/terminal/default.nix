{
  inputs,
  system,
  ...
}: {
  imports = [
    ./shell/starship.nix
    ./shell/nushell.nix

    inputs.ow1nvim.homeManagerModules.default
  ];

  programs.neovim-flake.enable = true;
}
