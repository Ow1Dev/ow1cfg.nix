{
  programs = {
    nushell = {
      enable = true;
      settings = {
        show_banner = false;
        buffer_editor = "nvim";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      environmentVariables = {
        EDITOR = "nvim";
      };
      shellAliases = {
        cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";
      };
    };
  };
}
