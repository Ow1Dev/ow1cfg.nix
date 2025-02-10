{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./keymaps.nix
    ./ui.nix
    ./neogit.nix
    ./window.nix
  ];

  programs.nixvim = {
    nixpkgs.pkgs = import <nixpkgs> { };

    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    clipboard.register = "unnamedplus"; # use system clipboard instead of internal registers

    globals.mapleader = " ";

    opts = {
      tabstop = 2; # insert 2 spaces for a tab
      softtabstop = 2;
      shiftwidth = 2;
      showbreak = "󰘍 ";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
}
