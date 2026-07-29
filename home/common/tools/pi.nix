{ pkgs, ... }: {
  programs.pi-coding-agent = {
    enable = true;
  };

  home.packages = [ pkgs.nodejs ];
}
