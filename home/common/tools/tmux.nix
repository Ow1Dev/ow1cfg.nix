{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;

    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    customPaneNavigationAndResize = true;
    keyMode = "vi";

    extraConfig = ''
      # --- NORD COLOR PALETTE ---
      set -g @nord0 "#2E3440"
      set -g @nord1 "#3B4252"
      set -g @nord2 "#434C5E"
      set -g @nord3 "#4C566A"
      set -g @nord4 "#D8DEE9"
      set -g @nord5 "#E5E9F0"
      set -g @nord6 "#ECEFF4"
      set -g @nord7 "#8FBCBB"
      set -g @nord8 "#88C0D0"
      set -g @nord9 "#81A1C1"
      set -g @nord10 "#5E81AC"
      set -g @nord11 "#BF616A"
      set -g @nord12 "#D08770"
      set -g @nord13 "#EBCB8B"
      set -g @nord14 "#A3BE8C"
      set -g @nord15 "#B48EAD"

      # --- GENERAL ---
      set -g status "on"
      set -g status-interval 5
      set -g status-justify "centre"

      # --- STATUS BAR ---
      set -g status-style "bg=#{@nord0},fg=#{@nord4}"

      # Left side
      set -g status-left-length 50
      set -g status-left "#[fg=#{@nord8},bold] #S #[fg=#{@nord3}]|#[fg=#{@nord4}] #I:#W "

      # Right side
      set -g status-right-length 100
      set -g status-right "#[fg=#{@nord3}]%Y-%m-%d #[fg=#{@nord8}]%H:%M #[fg=#{@nord3}]| #[fg=#{@nord14}]#(whoami)"

      # --- WINDOWS ---
      set -g window-status-format "#[fg=#{@nord3}]#I:#W"
      set -g window-status-current-format "#[fg=#{@nord8},bold]#I:#W"

      set -g window-status-style "bg=#{@nord0},fg=#{@nord3}"
      set -g window-status-current-style "bg=#{@nord1},fg=#{@nord8}"

      # --- PANE BORDERS ---
      set -g pane-border-style "fg=#{@nord3}"
      set -g pane-active-border-style "fg=#{@nord8}"

      # --- MESSAGE STYLE ---
      set -g message-style "bg=#{@nord1},fg=#{@nord4}"
      set -g message-command-style "bg=#{@nord1},fg=#{@nord8}"

      # --- MODE (copy mode etc.) ---
      set -g mode-style "bg=#{@nord3},fg=#{@nord6}"

      # --- SESH + TELEVISION BINDING ---
      bind-key T display-popup -E -w 80% -h 70% -d "#{pane_current_path}" -T "Sesh" "$SHELL -lc 'tv sesh'"
    '';
  };
}
