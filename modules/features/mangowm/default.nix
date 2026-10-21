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
        ${pkgs.lib.getExe pkgs.grim} -g "$geometry" "$output"
      else
        ${pkgs.lib.getExe pkgs.grim} "$output"
      fi
      ${pkgs.lib.getExe pkgs.libnotify} "Screenshot saved" "$output"
    '';

    packages.mangowc = inputs.wrappers.wrappers.mangowc.wrap {
      inherit pkgs;

      # Nightly from the mangowm flake input — nixpkgs 0.12.8 has the old
      # mmsg CLI and no tag_num; the bar's workspace IPC needs the new one.
      package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;

      settings = {
        xkb_rules_layout = "dk";

        # Nord palette copied from Quickshell's modules/core/Nord.qml.
        # Mango colors use RRGGBBAA (alpha last).
        root_color = "0x2e3440ff";
        border_color = "0x4c566aff";
        focus_color = "0x88c0d0ff";
        urgent_color = "0xbf616aff";
        drop_color = "0x88c0d055";
        split_color = "0xebcb8bff";
        maximized_screen_color = "0xa3be8cff";
        scratchpad_color = "0x81a1c1ff";
        global_color = "0xb48eadff";
        overlay_color = "0x8fbcbbff";
        shadows_color = "0x2e344066";

        # Overview jump labels.
        jump_label_decorate_fg_color = "0xeceff4ff";
        jump_label_decorate_bg_color = "0x3b4252ff";
        jump_label_decorate_focus_fg_color = "0x2e3440ff";
        jump_label_decorate_focus_bg_color = "0x88c0d0ff";
        jump_label_decorate_border_color = "0x4c566aff";

        # Group and tab decorations use the same surfaces as the launcher.
        group_bar_decorate_fg_color = "0xd8dee9ff";
        group_bar_decorate_bg_color = "0x3b4252ff";
        group_bar_decorate_focus_fg_color = "0x2e3440ff";
        group_bar_decorate_focus_bg_color = "0x88c0d0ff";
        group_bar_decorate_border_color = "0x4c566aff";
        group_bar_button_color = "0x88c0d0ff";
        tab_bar_decorate_fg_color = "0xd8dee9ff";
        tab_bar_decorate_bg_color = "0x3b4252ff";
        tab_bar_decorate_focus_fg_color = "0x2e3440ff";
        tab_bar_decorate_focus_bg_color = "0x88c0d0ff";
        tab_bar_decorate_border_color = "0x4c566aff";

        # autostart (wrapper's autostart_sh emits `exec-once`, which nightly
        # renamed to `exec_once`)
        exec_once = [
          "${pkgs.lib.getExe self'.packages.wpaperd} -d"
          (pkgs.lib.getExe self'.packages.quickshell)
          (pkgs.lib.getExe self'.packages.nord-idle)
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
          "layer_name:^nord-session$,no_blur:1"
        ];

        bind =
          [
            "SUPER,r,reload_config"
            "SUPER+SHIFT,l,spawn,${pkgs.lib.getExe self'.packages.nord-lock}"
            "SHIFT,Print,spawn_shell,${pkgs.lib.getExe self'.packages.screenshot} --area"
            "NONE,Print,spawn_shell,${pkgs.lib.getExe self'.packages.screenshot}"

            "SUPER,Return,spawn,foot"
            "ALT,d,spawn,${pkgs.lib.getExe self'.packages.quickshell} ipc call launcher toggle"

            "ALT,h,focusdir,left"
            "ALT,l,focusdir,right"
            "ALT,k,focusdir,up"
            "ALT,j,focusdir,down"

            "ALT+SHIFT,k,exchange_client,up"
            "ALT+SHIFT,j,exchange_client,down"
            "ALT+SHIFT,h,exchange_client,left"
            "ALT+SHIFT,l,exchange_client,right"

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
          "ALT,btn_left,moveresize,curmove"
          "ALT,btn_right,moveresize,curresize"
        ];
      };
    };
  };
}
