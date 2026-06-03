{ pkgs, ... }: {
  home.packages = [ pkgs.opencode ];

  home.file.".config/opencode/config.json".text = ''
    {
      "autoupdate": false
    }
  '';
}
