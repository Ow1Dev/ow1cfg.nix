{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./keymaps.nix
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
      showbreak = "󰘍 ";
      relativenumber = true; # show relative linenumbers
      laststatus = 0; # Display status line always

      wrap = false; # Don't wrap lines
      linebreak = true; # Wrap lines at convenient points

      # ================ Indentation ======================
      autoindent = true;
      cindent = true; # automatically indent braces
      smartindent = true;
      smarttab = true;
      shiftwidth = 4;
      softtabstop = 4;
      tabstop = 4;
      expandtab = true;

      # ================ Scrolling ========================
      scrolloff = 4; # Start scrolling when we're 4 lines away from margins
      sidescrolloff = 15;
      sidescroll = 1;

      # ================ Search and Replace ========================
      incsearch = true; # searches incrementally as you type instead of after 'enter'
      hlsearch = true; # highlight search results
      ignorecase = true; # search case insensitive
      smartcase = true; # search matters if capital letter
      inccommand = "split"; # preview incremental substitutions in a split

      # ================ Movement ========================
      backspace = "indent,eol,start"; # allow backspace in insert mode
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
}
