{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;

      # Raw qemu.conf content:
      verbatimConfig = ''
        user = "qemu"
        group = "kvm"
        dynamic_ownership = 1
      '';
    };
  };

  programs.virt-manager.enable = true;
}
