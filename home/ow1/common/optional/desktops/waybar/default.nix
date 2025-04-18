{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        marginTop = 10;
        marginLeft = 20;
        marginRight = 20;
        height = 41;

        modules-left = [
          "cpu"
          "memory"
          "disk"
        ];

        modules-center = [
          "niri/workspaces"
        ];

        modules-right = [
          "niri/language"
          "pulseaudio"
          "pulseaudio#microphone"
          "clock"
          "custom/separator"
          "tray"
        ];

        tray = {
          iconSize = 16;
          iconTheme = "Papirus";
          spacing = 2;
        };

        customSpacer = {
          format = " "; # Empty space
          tooltip = false;
        };

        separator = {
          format = " | ";
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "default" = "";
          };
        };

        clock = {
          tooltipFormat = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "<span color='#89b4fa'>󰥔 </span><span color='#cdd6f4'>{:%H:%M | %a %d %b}</span>";
          formatAlt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "<span color='#89b4fa'>󰍛</span> <span color='#cdd6f4'>{usage}%</span>";
          interval = 1;
          formatAltClick = "click";
          formatAlt = "<span color='#00FF00'>{icon0}{icon1}{icon2}{icon3}</span> <span color='#FFFFFF'>{usage:>2}%</span> <span color='#00FF00'>󰍛</span>";
          formatIcons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          onClick = "gnome-system-monitor";
        };

        memory = {
          interval = 3;
          format = "<span color='#f38ba8'> </span> <span color='#cdd6f4'>{used:0.1f}G</span>";
        };

        pulseaudio = {
          format = "<span color='#a6e3a1'>{icon} </span><span color='#cdd6f4'>{volume}%</span>";
          formatBluetooth = "<span color='#a6e3a1'>{icon}</span>  <span color='#cdd6f4'>{volume}%</span>";
          tooltip = false;
          formatMuted = "<span color='#f38ba8'>󰝟</span>";
          onClick = "wpctl set-mute @DEFAULT_SINK@ toggle";
          onScrollUp = "wpctl set-volume @DEFAULT_SINK@ 10%+";
          onScrollDown = "wpctl set-volume @DEFAULT_SINK@ 10%-";
          formatIcons = {
            headphone = "";
            handsFree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          formatSource = "<span color='#f38ba8'> </span><span color='#cdd6f4'>{volume}%</span>";
          formatSourceMuted = "";
          onClick = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
          onScrollUp = "wpctl set-volume @DEFAULT_SOURCE@ 5%+";
          onScrollDown = "wpctl set-volume @DEFAULT_SOURCE@ 5%-";
        };

        "niri/language" = {
          format = "<span color='#f9e2af'>󰌌</span> <span color='#cdd6f4'>{}</span>";
          formatEn = "eng";
        };

        disk = {
          interval = 3;
          path = "/home";
          format = "<span color='#a6e3a1'> </span><span color='#cdd6f4'>{free}</span>";
          unit = "GB";
        };
      }
    ];

    style = builtins.readFile (./. + "/style.css");
  };
}
