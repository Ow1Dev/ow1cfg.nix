{inputs, moduleWithSystem, ...}: {
  flake.nixosModules.hyprlock = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.nord-lock];
    programs.hyprlock = {
      enable = true;
      package = self'.packages.hyprlock;
    };
  });
  perSystem = {pkgs, self', ...}: let
    battery = pkgs.writeShellScript "nord-lock-battery" ''
      for device in /sys/class/power_supply/*; do
        [ -r "$device/type" ] || continue
        [ "$(cat "$device/type")" = Battery ] || continue
        [ -r "$device/capacity" ] || continue
        printf '▰ %s%%' "$(cat "$device/capacity")"
        exit 0
      done
    '';
  in {
    packages.hyprlock = inputs.wrappers.wrappers.hyprlock.wrap {
      inherit pkgs;
      extraConfig = builtins.replaceStrings ["@battery@"] ["${battery}"] (builtins.readFile ./hyprlock.conf);
    };
    packages.nord-lock = pkgs.writeShellScriptBin "nord-lock" ''
      # Serialize launches from the bar, idle daemon and keyboard shortcut.
      exec ${pkgs.util-linux}/bin/flock -n "$XDG_RUNTIME_DIR/nord-lock.lock" \
        ${pkgs.lib.getExe self'.packages.hyprlock}
    '';
  };
}
