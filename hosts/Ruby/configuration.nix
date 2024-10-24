# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  # Additional Modules
  imports = [
    ./../../nixosModules
  ];
  
    # Boot kernel parameters:
  boot.kernelParams = [
    # Mitigate screen flickering, see:
    # https://wiki.archlinux.org/title/intel_graphics#Screen_flickering
    # https://github.com/linux-surface/linux-surface/issues/862
    "i915.enable_psr=0"
  ];

  boot.initrd.kernelModules = [
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "surface_hid"
    "pinctrl_tigerlake"
    "intel_lpss"
    "intel_lpss_pci"
    "8250_dw"
  ];

  microsoft-surface.surface-control.enable = true;
  microsoft-surface.kernelVersion = "surface-devel";

  # Disable the problematic suspend kernel module, it makes waking up
  # impossible after closing the cover.
  boot.blacklistedKernelModules = [
    "surface_gpe"
  ];

  modules = {
    lsp.enable = true;
    js-dev.enable = true;
    vm.enable = true;
  };

  stylix.image = /home/noah/Documents/System/wallpapers/contemplate.png;

  grub = {
    enable = true;
    useOSProber = true;
  };

  networking.hostName = "Ruby";

  # Enable touchpad support 
  services.xserver.libinput.enable = true;

  # Enable brightness control via light
  programs.light.enable = true;
  users.users.noah.extraGroups = [ "video" ];

  # Additional Packages
  environment.systemPackages = with pkgs; [
    networkmanager-openvpn
  ];

  system.stateVersion = "23.11"; # Don't touch this
}

