{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      nix_shell = {
        disabled = false;
        heuristic = false;
        format = "[   ](fg:blue bold)";
        impure_msg = "";
        pure_msg = "";
        unknown_msg = "";
      };
    };
  };
}
