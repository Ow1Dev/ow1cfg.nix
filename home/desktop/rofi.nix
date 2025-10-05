{ pkgs, config, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
        modi = "drun";
        show-icons = true;
        display-drun = "";
        drun-display-format = "{name}";
    };
    theme = let 
      inherit (config.lib.formats.rasi) mkLiteral;

      colors = {
        foreground = mkLiteral "#E5E9F0FF";
        selected = mkLiteral "#81A1C1FF";
        backgroundAlt = mkLiteral "#383E4AFF";
      };
    in {
      /*****----- Main Window -----*****/
      window = {
        transparency =                "real";
        location =                    mkLiteral "center";
        anchor =                      mkLiteral "center";
        fullscreen =                  true;
        width =                       1366;
        height =                      768;
        x-offset =                    0;
        y-offset =                    0;

        enabled =                     true;
        margin =                      0;
        padding =                     0;
        border =                      mkLiteral "0px solid";
        border-radius =               0;
        border-color =                colors.selected;
        background-color =            mkLiteral "black / 65%";
        cursor =                      "default";
      };

      /*****----- Main Box -----*****/
      mainbox = {
        enabled =                     true;
        spacing =                     100;
        margin =                      0;
        padding =                     mkLiteral "100px 225px";
        border =                      mkLiteral "0px solid";
        border-radius =               mkLiteral "0px 0px 0px 0px";
        border-color =                colors.selected;
        background-color =            mkLiteral "transparent";
        children =                    [ "inputbar" "listview" ];
      };

      /*****----- Inputbar -----*****/
      inputbar = {
        enabled =                     true;
        spacing =                     mkLiteral "10px";
        margin =                      mkLiteral "0% 28%";
        padding =                     mkLiteral "10px";
        border =                      mkLiteral "1px solid";
        border-radius =               mkLiteral "6px";
        border-color =                mkLiteral "white / 25%";
        background-color =            mkLiteral "white / 5%";
        text-color =                  colors.foreground;
        children =                    [ "prompt" "entry" ];
      };

      prompt = {
        enabled =                     true;
        background-color =            mkLiteral "transparent";
        text-color =                  mkLiteral "inherit";
      };

      textbox-prompt-colon = {
        enabled =                     true;
        expand =                      false;
        str =                         "::";
        background-color =            mkLiteral "transparent";
        text-color =                  mkLiteral "inherit";
      };

      entry = {
        enabled =                     true;
        background-color =            mkLiteral "transparent";
        text-color =                  mkLiteral "inherit";
        cursor =                      mkLiteral "text";
        placeholder =                 "Search";
        placeholder-color =           mkLiteral "inherit";
      };

      /*****----- Listview -----*****/
      listview = {
        enabled =                     true;
        columns =                     7;
        lines =                       4;
        cycle =                       true;
        dynamic =                     true;
        scrollbar =                   false;
        layout =                      mkLiteral "vertical";
        reverse =                     false;
        fixed-height =                true;
        fixed-columns =               true;

        spacing =                     mkLiteral "0px";
        margin =                      mkLiteral "0px";
        padding =                     mkLiteral "0px";
        border =                      mkLiteral "0px solid";
        border-radius =               mkLiteral "0px";
        border-color =                colors.selected;
        background-color =            mkLiteral "transparent";
        text-color =                  colors.foreground;
        cursor =                      mkLiteral "default";
      };

      scrollbar = {
        handle-width =                mkLiteral "5px";
        handle-color =                colors.selected;
        border-radius =               mkLiteral "0px";
        background-color =            colors.backgroundAlt;
      };

      /*****----- Elements -----*****/
      element = {
        enabled =                     true;
        spacing =                     mkLiteral "15px";
        margin =                      mkLiteral "0px";
        padding =                     mkLiteral "35px 10px";
        border =                      mkLiteral "0px solid";
        border-radius =               mkLiteral "15px";
        border-color =                colors.selected;
        background-color =            mkLiteral "transparent";
        text-color =                  colors.foreground;
        orientation =                 mkLiteral "vertical";
        cursor =                      mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color =            mkLiteral "transparent";
        text-color =                  colors.foreground;
      };

      "element selected.normal" = {
        background-color =            mkLiteral "white / 5%";
        text-color =                  colors.foreground;
      };

      element-icon = {
        background-color =            mkLiteral "transparent";
        text-color =                  mkLiteral "inherit";
        size =                        mkLiteral "72px";
        cursor =                      mkLiteral "inherit";
      };

      element-text = {
        background-color =            mkLiteral "transparent";
        text-color =                  mkLiteral "inherit";
        highlight =                   mkLiteral "inherit";
        cursor =                      mkLiteral "inherit";
        vertical-align =              mkLiteral "0.5";
        horizontal-align =            mkLiteral "0.5";
      };

      /*****----- Message -----*****/
      error-message = {
        padding =                     mkLiteral "100px";
        border =                      mkLiteral "0px solid";
        border-radius =               mkLiteral "0px";
        border-color =                colors.selected;
        background-color =            mkLiteral "black / 10%";
        text-color =                  colors.foreground;
      };

      textbox = {
        background-color =            mkLiteral "transparent";
        text-color =                  colors.foreground;
        vertical-align =              mkLiteral "0.5";
        horizontal-align =            mkLiteral "0.0";
        highlight =                   mkLiteral "none";
      };
    };
  };
}
