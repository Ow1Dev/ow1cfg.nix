{ ... }:
{
    programs.waybar = {
      enable = true;

      settings = [
        {
          position = "bottom";
          layer = "top";
          height = 5;
          margin-top = 0;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          modules-left = [
            "custom/launcher"
            "niri/workspaces"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
            "cpu"
            "memory"
            "disk"
            "pulseaudio"
            "battery"
            "network"
            "custom/notification"
          ];
          clock = {
            calendar = {
              format = {today = "<span color='#b4befe'><b><u>{}</u></b></span>";};
            };
            format = " {:%H:%M}";
            tooltip = "true";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = " {:%d/%m}";
          };
          "niri/workspaces" = {
            all-outputs = true;
            disable-scroll = true;
            on-click = "activate";
            format = "{icon}";
            format-icons = { default = ""; };
          };
          memory = {
            format = "󰟜 {}%";
            format-alt = "󰟜 {used} GiB"; # 
            interval = 2;
          };
          cpu = {
            format = "  {usage}%";
            format-alt = "  {avg_frequency} GHz";
            interval = 2;
          };
          disk = {
            # path = "/";
            format = "󰋊 {percentage_used}%";
            interval = 60;
          };
          network = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰀂 ";
            tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 ";
          };
          tray = {
            icon-size = 20;
            spacing = 8;
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "  {volume}%";
            format-icons = {
              default = [" "];
            };
            scroll-step = 5;
            on-click = "pamixer -t";
          };
          battery = {
            format = "{icon} {capacity}%";
            format-icons = [" " " " " " " " " "];
            format-charging = " {capacity}%";
            format-full = " {capacity}%";
            format-warning = " {capacity}%";
            interval = 5;
            states = {
              warning = 20;
            };
            format-time = "{H}h{M}m";
            tooltip = true;
            tooltip-format = "{time}";
          };
          "custom/launcher" = {
            format = "";
            on-click = "fuzzel";
            on-click-right = "wallpaper-picker";
            tooltip = "false";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} ";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>   ";
              none = "   ";
              dnd-notification = "<span foreground='red'><sup></sup></span>   ";
              dnd-none = "   ";
              inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
              inhibited-none = "   ";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
              dnd-inhibited-none = "   ";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
        }
      ];

      style = builtins.readFile (./. + "/style.css");
    };
}
