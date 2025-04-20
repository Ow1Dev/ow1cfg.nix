{
  pkgs,
  config,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    extraConfig = {
      modi = "drun";
      show-icons = true;
      display-drun = "";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background = mkLiteral "#1E1D2FFF";
          background-alt = mkLiteral "#282839FF";
          foreground = mkLiteral "#D9E0EEFF";
          selected = mkLiteral "#7AA2F7FF";
          active = mkLiteral "#ABE9B3FF";
          urgent = mkLiteral "#F28FADFF";
          font = "JetBrainsMono Nerd Font";
        };

        window = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = false;
          width = mkLiteral "700px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";

          enabled = true;
          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "@background";
          cursor = mkLiteral "default";
        };

        mainbox = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0px";
          padding = mkLiteral "20px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "0px 0px 0px 0px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "transparent";
          children = mkLiteral "[ \"inputbar\", \"listview\" ]";
        };

        inputbar = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0px";
          padding = mkLiteral "15px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          children = mkLiteral "[ \"prompt\", \"entry\" ]";
        };

        prompt = {
          enabled = true;
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        textbox-prompt-colon = {
          enabled = true;
          expand = false;
          str = "::";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        entry = {
          enabled = true;
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "text";
          placeholder = "Search...";
          placeholder-color = mkLiteral "inherit";
        };

        listview = {
          enabled = true;
          columns = 2;
          lines = 8;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
        
          spacing = mkLiteral "5px";
          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = "default";
        };
        scrollbar = {
          handle-width = mkLiteral "5px";
          handle-color = mkLiteral "@selected";
          border-radius = mkLiteral "0px";
          background-color = mkLiteral "@background-alt";
        };

        element = {
          enabled = true;
          spacing = mkLiteral "10px";
          margin = mkLiteral "0px";
          padding = mkLiteral "5px";
          border = mkLiteral "0px solid";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "pointer";
        };

        "element normal.normal" = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@background";
        };
        element-icon = {
          background-color =  mkLiteral "transparent";
          text-color =  mkLiteral "inherit";
          size =  mkLiteral "32px";
          cursor =  mkLiteral "inherit";
        };
        element-text = {
          background-color =  mkLiteral "transparent";
          text-color =  mkLiteral "inherit";
          highlight = mkLiteral "inherit";
          cursor =  mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        error-message = {
          padding = mkLiteral "15px";
          border = mkLiteral "2px solid";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@selected";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
        };
        textbox = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
          highlight = mkLiteral "none";
        };
      };
  };
}
