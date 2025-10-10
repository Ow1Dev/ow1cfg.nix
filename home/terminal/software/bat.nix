{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      style = "plain";
      theme = "Nord";
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}
