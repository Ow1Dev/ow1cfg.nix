{
  self,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    ./git.nix

    ../common/terminal/ghostty.nix
    # ../common/browser/librewolf.nix
    ../common/browser/helium.nix

    ../common/shell/zsh.nix

    ../common/tools/tmux.nix
    ../common/tools/zoxide.nix
    ../common/tools/direnv.nix

    ../common/tools/sesh-television.nix
    ../common/tools/opencode.nix
  ];

  home.packages = with pkgs; [
    # my neovim config
    self.packages.${stdenv.hostPlatform.system}.neovim

    lazygit
    gh
    devenv
  ];

  home.stateVersion = "25.11";
}
