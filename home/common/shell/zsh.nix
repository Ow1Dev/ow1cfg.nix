{ ... }: {
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;

    initContent = ''
      # Completion (only once!)
      autoload -Uz compinit
      compinit

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      setopt PROMPT_SUBST

      # vcs_info setup (fast git info)
      autoload -Uz vcs_info
      precmd_functions+=(vcs_info)

      zstyle ':vcs_info:git:*' enable yes
      zstyle ':vcs_info:git:*' formats ' (%b)'
      zstyle ':vcs_info:git:*' actionformats ' (%b|%a)'
      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' unstagedstr '*'
      zstyle ':vcs_info:git:*' stagedstr '+'

      # Colors (zsh-native)
      autoload -Uz colors && colors

      in_nix() {
        [[ -n "$IN_NIX_SHELL" ]] && echo "  "
      }

      get_path() {
        local path="$PWD"

        if [[ "$path" == "$HOME"* ]]; then
          echo "''${path#$HOME}"
        else
          echo "$path"
        fi
      }

      PROMPT='%{$fg[blue]%}$(in_nix)%~%{$fg[green]%}''${vcs_info_msg_0_} %{$fg[grey]%}$ %{$reset_color%}'

      bindkey -e
    '';
  };
}
