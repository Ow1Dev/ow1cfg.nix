{pkgs, ...}: {
  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false;
    icons = true;
  };

  programs.television = {
    enable = true;
    channels.sesh = {
      metadata = {
        name = "sesh";
        description = "Session manager integrating tmux sessions, zoxide directories, and config paths";
        requirements = ["sesh" "fd"];
      };
      source = {
        command = "sesh list --icons";
        ansi = true;
        output = "{strip_ansi|split: :1..|join: }";
      };
      preview.command = "sesh preview '{strip_ansi|split: :1..|join: }'";
      keybindings = {
        enter = "actions:connect";
        "ctrl-d" = ["actions:kill_session" "reload_source"];
      };
      actions.connect = {
        description = "Connect to selected session";
        command = "sesh connect '{strip_ansi|split: :1..|join: }'";
        mode = "execute";
      };
      actions.kill_session = {
        description = "Kill selected tmux session (press Ctrl+r to reload)";
        command = "tmux kill-session -t '{strip_ansi|split: :1..|join: }'";
        mode = "fork";
      };
    };
  };
 }
