{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;

    initContent = ''
      autoload -Uz compinit
      compinit

      setopt PROMPT_SUBST

      autoload -Uz colors && colors

      parse_git_root() {
        git rev-parse --show-toplevel 2>/dev/null
      }

      parse_git_branch() {
        git rev-parse --abbrev-ref HEAD 2>/dev/null
      }

      in_nix() {
        [[ -n "$IN_NIX_SHELL" ]] && echo "  "
      }

      get_path() {
        local root
        root=$(parse_git_root)
        [[ -n "$root" ]] && echo "$PWD" | sed "s|^$root|$(basename "$root")|; s|^/||" && return
        case "$PWD" in
          ''${HOME}*) echo "~''${PWD#$HOME}" ;;
          *) echo "$PWD"
        esac
      }

      PROMPT='%F{blue}$(in_nix)$(get_path)%F{green}$(b=$(parse_git_branch); [[ -n "$b" ]] && echo " ($b)") %F{8}$ %f'

      bindkey -e
    '';
  };
}
