{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.ow1 = {
    initialHashedPassword = "$y$j9T$17zmqV.kbcjuXAoYpYq3g.$ke8glHpaUYLwf9S.bH53P1qmupgOySnasBoMZFjxYYA";
    isNormalUser = true;
    description = "ow1";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAYeP7UM4WKjh9d6M8xelpPi2kN1Cv4SjoAsFujcVR8 ow1@Ow1PC"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.ow1 =
    import ../../../home/ow1/${config.networking.hostName}.nix;
}