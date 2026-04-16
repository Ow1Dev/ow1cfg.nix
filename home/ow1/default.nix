{
  self,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    ./git.nix

    ../common/terminal/ghostty.nix
    ../common/shell/zsh.nix
  ];

  home.packages = with pkgs; [
    # my neovim config
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  ];

  home.stateVersion = "25.11";
}
