{pkgs, ...}:
# nix tooling
{
  home.packages = with pkgs; [alejandra deadnix statix];

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
