{
  self,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    ./git.nix

    ../common/terminal/ghostty.nix
    ../common/browser/librewolf.nix

    ../common/shell/zsh.nix

    ../common/tools/tmux.nix
    ../common/tools/zoxide.nix
    ../common/tools/direnv.nix

    ../common/tools/sesh-television.nix
  ];

  home.packages = with pkgs; [
    # my neovim config
    self.packages.${stdenv.hostPlatform.system}.neovim

    # opencode from overlay
    opencode
    lazygit
  ];

  home.stateVersion = "25.11";
}
