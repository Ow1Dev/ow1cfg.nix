{ ... }: {
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;

    initContent = ''
      autoload -Uz compinit
      compinit

      setopt PROMPT_SUBST

      autoload -Uz colors && colors

      parse_git_branch() {
        git rev-parse --abbrev-ref HEAD 2>/dev/null
      }

      in_nix() {
        [[ -n "$IN_NIX_SHELL" ]] && echo "  "
      }

      get_path() {
        local path="$PWD"

        if git rev-parse --is-inside-work-tree &>/dev/null; then
          local root
          root=$(git rev-parse --show-superproject-working-tree 2>/dev/null)

          # fallback if not submodule
          if [[ -z "$root" ]]; then
            root=$(git rev-parse --show-toplevel 2>/dev/null)
          fi

          local rel="''${path#$root}"
          rel="''${rel#/}"

          if [[ -z "$rel" ]]; then
            echo "$(basename "$root")"
          else
            echo "$(basename "$root")/''${rel}"
          fi
          return
        fi

        if [[ "$path" == "$HOME"* ]]; then
          echo "~''${path#$HOME}"
        else
          echo "$path"
        fi
      }

      get_git_branch() {
        local b
        b=$(parse_git_branch)
        [[ -n "$b" ]] && echo " (''${b})"
      }

      PROMPT='%{$fg[blue]%}$(in_nix)$(get_path)%{$fg[green]%}$(get_git_branch) %{$fg[grey]%}$ %{$reset_color%}'

      bindkey -e
    '';
  };
}
