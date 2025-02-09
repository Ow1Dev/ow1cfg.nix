{
  config,
  pkgs,
  lib,
  home,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      autoload bashcompinit && bashcompinit
      autoload -Uz compinit
      compinit

      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'

      bindkey -e
    '';

    shellAliases = {
      ls = "eza --color=always --group-directories-first --icons";
      ll = "eza -la --icons --octal-permissions --group-directories-first";
    };

    dotDir = ".config/zsh";
    history.path = "${config.home.homeDirectory}/.config/zsh/.zsh_history";
  };

  home.packages = with pkgs; [
    eza
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.strings.concatStrings [
        "$nix_shell"
        "$os"
        "$directory"
        "$container"
        "$git_branch $git_status"
        "$python"
        "$nodejs"
        "$lua"
        "$rust"
        "$java"
        "$c"
        "$golang"
        "$cmd_duration"
        "$status"
        "\n$character"
      ];
      git_branch.symbol = " ";
      git_commit.tag_disabled = false;
      git_status = {
        ahead = ''⇡''${count}'';
        behind = ''⇣''${count}'';
        diverged = ''⇕⇡''${ahead_count}⇣''${behind_count}'';
        staged = "+$count";
      };
      kubernetes.disabled = false;
      time.disabled = false;
    };
  };
}
