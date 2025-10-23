{pkgs, ...}: {
  imports = [
    ./chromium-flags.nix
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # Ublock Origin
    ];
  };
}
