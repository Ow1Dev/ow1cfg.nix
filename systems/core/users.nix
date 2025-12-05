{pkgs, ...}: {
  environment.shells = with pkgs; [nushell];

  users.users.ow1 = {
    isNormalUser = true;
    description = "ow1";
    shell = pkgs.nushell;
    extraGroups = ["networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm"];
    packages = [];
  };
}
