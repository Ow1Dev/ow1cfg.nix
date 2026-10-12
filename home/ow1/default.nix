{
  self,
  pkgs,
  config,
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

  home.sessionVariables = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";

    SSL_CERT_DIR = "${config.home.homeDirectory}/.aspnet/dev-certs/trust:/etc/ssl/certs";

    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = with pkgs; [
    # my neovim config
    self.packages.${stdenv.hostPlatform.system}.nvim

    lazygit
    herdr
    gh
    devenv
    httpie
    ripgrep

    spotify
  ];

  home.stateVersion = "25.11";
}
