{moduleWithSystem, ...}: {
  flake.nixosModules.hypridle = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.nord-idle];
  });
  perSystem = {pkgs, self', ...}: let
    idleConfig = pkgs.writeText "nord-hypridle.conf" (
      builtins.replaceStrings
      ["@lock@" "@loginctl@" "@wlopm@" "@brightnessctl@"]
      ["${pkgs.lib.getExe self'.packages.nord-lock}" "${pkgs.systemd}/bin/loginctl" "${pkgs.lib.getExe pkgs.wlopm}" "${pkgs.lib.getExe pkgs.brightnessctl}"]
      (builtins.readFile ./hypridle.conf)
    );
  in {
    packages.nord-idle = pkgs.writeShellScriptBin "nord-idle" ''
      exec ${pkgs.util-linux}/bin/flock -n "$XDG_RUNTIME_DIR/nord-idle.lock" \
        ${pkgs.lib.getExe pkgs.hypridle} --config ${idleConfig}
    '';
  };
}
