{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.zsh = moduleWithSystem ({
    pkgs,
    self',
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        zsh = self'.packages.zsh;
      })
    ];
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
    };
    users.defaultUserShell = pkgs.zsh;
  });
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.zsh = inputs.wrappers.wrappers.zsh.wrap {
      inherit pkgs;
      runtimePkgs = [pkgs.devenv];
      zshrc.content = ''
        autoload -U compinit && compinit
        export EDITOR=nvim

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

        setopt PROMPT_SUBST
        PROMPT='%F{blue}$(in_nix)$(get_path)%F{green}$(b=$(parse_git_branch); [[ -n "$b" ]] && echo " ($b)") %F{8}$ %f'

        eval "$(${lib.getExe pkgs.devenv} hook zsh)"
      '';
    };
  };
}
