{inputs, ...}: {
  imports = [
    inputs.sherlock.homeManagerModules.default
  ];

  programs.sherlock = {
    enable = true;
    settings = {
        launchers = [
            {
                name = "App Launcher";
                type = "app_launcher";
                args = {};
                priority = 1;
                home = true;
            }
            {
                name = "Calculator";
                type = "calculation";
                args = {};
                priority = 1;
            }
            {
                name = "Web Search";
                display_name = "Google Search";
                tag_start = "{keyword}";
                alias = "gg";
                type = "web_launcher";
                args =  {
                    search_engine = "google";
                    icon = "google";
                };
                priority = 100;
            }
            {
                name = "Nix Search";
                display_name = "Nix Search";
                tag_start = "{keyword}";
                alias = "nx";
                type = "web_launcher";
                args = {
                    search_engine = "https://search.nixos.org/packages?query={keyword}";
                    icon = "sherlock-nix";
                };
                priority = 0;
            }
        ];
    };
  };

  home.file.".config/sherlock/main.css".text = ''
:root {
    /* backgrounds */ 
    --background: 240, 21%, 15%;
    --background-soft: 240, 21%, 12;
    --background-alt: 240, 23%, 9%;
    --border: 267, 84%, 81%;
    --text: 226, 64%, 88%;
    --text-active: 267, 84%, 81%;

    /* foreground */
    --foreground: 237, 16%, 23;
    --foreground-soft: 240, 21%, 15%;

    /* accent colors */
    --error: 343, 81%, 75%;
    --success: 115, 54%, 76%;
    --warning: 41d, 86%, 83%;
    --blue: 217, 92%, 76%;
    --purple: 232, 97%, 85%;
    --aqua: 199, 76%, 69%;
    --orange: 23, 92%, 75%;
}

/* Will make icons inside active tile black else white */
#search-icon-holder image,
image.reactive {
    -gtk-icon-filter: brightness(10) saturate(100%) contrast(100%); /* white */
}
.tile:selected image.reactive {
    -gtk-icon-filter: brightness(0) saturate(100%) contrast(100%); /* black */
}

/* TILES */
.tile:selected #title {
    color: hsla(var(--text-active), 0.7);
}

.tile #icon {
    margin: 0px;
    padding: 0px;
}

.tile:selected {
    color: hsl(var(--text-active));
    transition: 0.1s ease;
    background: hsla(var(--foreground), 1);
    background-color: hsla(var(--foreground), 1);
    outline: none;
    border: none;
}

.tile:selected .tag,
.tag {
    font-size: 11px;
    border-radius: 3px;
    padding: 2px 8px;
    color: hsl(var(--tag-color));
    box-shadow: 0px 0px 10px 0px hsla(var(--background), 0.1);
    border: 1px solid hsla(var(--text-active), 0.1);
    margin-left: 7px;
}

.tile:selected .tag-start,
.tag-start {
    background: hsla(var(--tag-background), 0.7);
}

.tile:selected .tag-end,
.tag-end {
    background: hsla(var(--success), 1);
}

.tile:selected #launcher-type {
    color: hsla(var(--text-active), 0.4);
}


/*SHORTCUT*/
#shortcut-holder {
    box-shadow: unset;
}
#shortcut-holder label {
    color: hsla(var(--text-active), 0.5);
}

/*EVENT TILE*/
.tile.event-tile:selected #time-label,
.tile.event-tile:selected #title-label{
    color: hsla(var(--text-active), 0.6);
} 

/* BULK TEXT TILE */
#bulk-text-content-title {
    color: hsla(var(--text-active), 0.9);
}

#bulk-text-content-body {
    color: hsla(var(--text-active), 0.7);
}
  '';
}
