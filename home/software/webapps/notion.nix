{config, ... }: {
  xdg.desktopEntries.notion = {
    name = "Notion";
    exec = "chromium --app=\"https://www.notion.so\"";
    icon = "${config.home.homeDirectory}/.local/share/icons/notion.png";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
  };

  home.file.".local/share/icons/notion.png".source = ./icons/notion.png;
}

