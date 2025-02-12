{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;

    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
      bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
      bind-key C-n command-prompt -p "New session name:" "new-session -s '%%'"
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
