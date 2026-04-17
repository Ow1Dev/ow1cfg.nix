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

    ../common/tools/tmux.nix
  ];

  home.packages = with pkgs; [
    # my neovim config
    self.packages.${stdenv.hostPlatform.system}.neovim

    opencode
  ];

  home.stateVersion = "25.11";
}
