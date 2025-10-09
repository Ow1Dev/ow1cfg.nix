{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        height = 34;
        width = 800;
        margin-top = 8;

        modules-left = ["niri/workspaces"];
        modules-center = ["clock"];
        modules-right = ["battery" "tray"];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "●";
            active = "●";
          };
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            format = {
              months = "<span color='#88c0d0'><b>{}</b></span>";
              days = "<span color='#d8dee9'>{}</span>";
              weekdays = "<span color='#81a1c1'><b>{}</b></span>";
              today = "<span color='#bf616a'><b>{}</b></span>";
            };
          };
        };
        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time}";

          format-icons = ["" "" "" "" ""]; # Icons for levels
          interval = 30; # Update interval in seconds
        };
        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(46, 52, 64, 0.85);
        border-bottom: 1px solid #181825;
        border-radius: 50px;
        color: #d8dee9;
        transition-property: background-color;
      }

      #workspaces,
      #clock,
      #tray,
      #battery {
        padding: 0 8px;
        margin: 6px 0px;
        transition: all 0.3s ease;
      }

      #workspaces {
        margin-left: 8px;
        padding: 0 8px;
      }

      #clock {
        color: #eceff4;
        font-weight: 500;
      }

      #tray {
        margin-right: 8px;
      }

      #workspaces button {
        padding: 0 10px;
        color: #4c566a;
        background: transparent;
        transition: all 0.3s ease;
        border-radius: 4px;
        margin: 2px 2px;
      }

      #workspaces button.active {
        color: #88c0d0;
      }

      #workspaces button:hover {
        color: #81a1c1;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: #bf616a;
      }

      tooltip {
        background: rgba(46, 52, 64, 0.95);
        border: 1px solid rgba(136, 192, 208, 0.3);
        border-radius: 6px;
        color: #d8dee9;
      }

      tooltip label {
        color: #d8dee9;
        padding: 4px;
      }
    '';
  };
}
