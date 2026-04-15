return {
	cmd = { 'nixd' },
	settings = {
    nixpkgs = {
	    expr = "import <nixpkgs> { }",
	  },
	  formatting = {
		  command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
	  },
	},
}
