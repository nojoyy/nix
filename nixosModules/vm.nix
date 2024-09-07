{ pkgs, lib, config, ... }:

let module = config.modules.vm;

in {
  options = {
    modules.vm.enable = lib.mkEnableOption "enable virtual machines";
  };

  config = lib.mkIf module.enable {
    
    # Add QEMU/VM Support
    virtualisation.libvirtd.enable = true;
    
    programs.virt-manager.enable = true;
    users.users.noah.extraGroups = [ "libvirtd" ];

    # Enable USB redirection
    virtualisation.spiceUSBRedirection.enable = true;
    
    environment.systemPackages = with pkgs; [
      virt-viewer
    ];
  };
}
