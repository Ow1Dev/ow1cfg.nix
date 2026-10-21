{moduleWithSystem, ...}: {
  flake.nixosModules.hypridle = moduleWithSystem ({self', pkgs, ...}: {
    environment.systemPackages = [self'.packages.nord-idle];
    services.udev.packages = [pkgs.brightnessctl];
  });
  perSystem = {pkgs, self', ...}: let
    idleConfig = pkgs.writeTextDir "hypr/hypridle.conf" (
      builtins.replaceStrings
      ["@lock@" "@wlopm@" "@brightnessctl@"]
      ["${pkgs.lib.getExe self'.packages.nord-lock}" "${pkgs.lib.getExe pkgs.wlopm}" "${pkgs.lib.getExe pkgs.brightnessctl}"]
      (builtins.readFile ./hypridle.conf)
    );
  in {
    packages.nord-idle = pkgs.writeShellScriptBin "nord-idle" ''
      # HyprIdle 0.1.7 also resolves a default config when --config is supplied.
      # Provide that lookup without modifying the user's config directory.
      export XDG_CONFIG_DIRS="${idleConfig}:''${XDG_CONFIG_DIRS:-/etc/xdg}"
      exec ${pkgs.util-linux}/bin/flock -n "$XDG_RUNTIME_DIR/nord-idle.lock" \
        ${pkgs.lib.getExe pkgs.hypridle} --config ${idleConfig}/hypr/hypridle.conf
    '';
  };
}
