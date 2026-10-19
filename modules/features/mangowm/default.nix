{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.mangowm = moduleWithSystem (
    {
      self',
      pkgs,
      ...
    }: {
      imports = [inputs.mangowm.nixosModules.mango];

      programs.mango = {
        enable = true;
        package = self'.packages.mangowc;
      };

      environment.systemPackages = with pkgs; [
        grim
        slurp
        wl-clipboard
        feh
      ];

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };

      services.xserver.enable = true;
      programs.firefox.enable = true;
    }
  );
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.screenshot = pkgs.writeShellScriptBin "mango-screenshot" ''
      set -eu
      mkdir -p "$HOME/Pictures/Screenshots"
      output="$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"
      if [ "''${1-}" = --area ]; then
        geometry=$(${pkgs.lib.getExe pkgs.slurp} -d)
        [ -n "$geometry" ] || exit 0
        exec ${pkgs.lib.getExe pkgs.grim} -g "$geometry" "$output"
      fi
      exec ${pkgs.lib.getExe pkgs.grim} "$output"
    '';

    packages.mangowc = inputs.wrappers.wrappers.mangowc.wrap {
      inherit pkgs;

      # Nightly from the mangowm flake input — nixpkgs 0.12.8 has the old
      # mmsg CLI and no tag_num; the bar's workspace IPC needs the new one.
      package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;

      settings = {
        xkb_rules_layout = "dk";

        # autostart (wrapper's autostart_sh emits `exec-once`, which nightly
        # renamed to `exec_once`)
        exec_once = [
          "${pkgs.lib.getExe self'.packages.wpaperd} -d"
          (pkgs.lib.getExe self'.packages.quickshell)
        ];

        # 5 workspace dots in the bar
        tag_num = 5;

        # Frosted layer surfaces (bar background)
        blur = 1;
        blur_layer = 1;
        blur_optimized = 0;

        # Keep background colors from bleeding into the launcher’s rounded edge.
        layer_rule = [
          "layer_name:^nord-launcher$,no_blur:1"
        ];

        bind =
          [
            "SUPER,r,reload_config"
            "SHIFT,Print,spawn_shell,${pkgs.lib.getExe self'.packages.screenshot} --area"
            "NONE,Print,spawn_shell,${pkgs.lib.getExe self'.packages.screenshot}"

            "SUPER,Return,spawn,foot"
            "ALT,d,spawn,${pkgs.lib.getExe self'.packages.quickshell} ipc call launcher toggle"

            "SUPER,h,focusdir,left"
            "SUPER,l,focusdir,right"
            "SUPER,k,focusdir,up"
            "SUPER,j,focusdir,down"

            "SUPER+SHIFT,k,exchange_client,up"
            "SUPER+SHIFT,j,exchange_client,down"
            "SUPER+SHIFT,h,exchange_client,left"
            "SUPER+SHIFT,l,exchange_client,right"

            "SUPER,f,togglemaximizescreen"
            "SUPER,space,togglefloating"

            "SUPER+SHIFT,q,quit"
            "SUPER,q,killclient"
          ]
          ++ builtins.concatMap (i: [
            "SUPER,${toString i},view,${toString i},0"
            "SUPER+SHIFT,${toString i},tag,${toString i},0"
          ]) (builtins.genList (i: i + 1) 5);

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];
      };
    };
  };
}
