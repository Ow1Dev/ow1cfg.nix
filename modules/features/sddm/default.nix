{...}: {
  flake.nixosModules.sddm = {pkgs, ...}: let
    nordSddmTheme = pkgs.stdenvNoCC.mkDerivation {
      pname = "nord-sddm-theme";
      version = "1.0";
      src = ./.;
      installPhase = ''
        themeDir=$out/share/sddm/themes/nord
        mkdir -p "$themeDir"
        cp ${./Main.qml} "$themeDir/Main.qml"
        cp ${./theme.conf} "$themeDir/theme.conf"
        cp ${./metadata.desktop} "$themeDir/metadata.desktop"
      '';
    };
  in {
    environment.systemPackages = [nordSddmTheme];
    services.displayManager.sddm = {
      enable = true;
      theme = "nord";
    };
  };
}
