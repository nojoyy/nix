{ pkgs, lib, config, ... }:

{
  
  options = {
    vm.enable = lib.mkEnableOption "enable virtual machines";
  };

  config = lib.mkIf config.vm.enable {
    
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
