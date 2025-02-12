{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
    '';
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'mocha'";
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
      }
    ];
  };
}
