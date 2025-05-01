 { inputs, ...}: {
  home = {
    packages = [
      inputs.ghostty
    ];
    file.".config/ghostty/config".text = ''
        theme = catppuccin-mocha
        gtk-single-instance = true
    '';
  };
 }
