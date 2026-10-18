{moduleWithSystem, ...}: {
  flake.nixosModules.chatgpt = moduleWithSystem ({unstablePkgs, ...}: {
    environment.systemPackages = with unstablePkgs; [
      chatgpt
    ];
  });
}
