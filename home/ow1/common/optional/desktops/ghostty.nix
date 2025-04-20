 { inputs, ...}: {
  home = {
    packages = [
      inputs.ghostty
    ];
    file.".config/ghostty/config".text = ''
        theme = catppuccin-mocha
    '';
  };
 }
