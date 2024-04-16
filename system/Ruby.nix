# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

    # Boot kernel parameters:
  boot.kernelParams = [
    # Mitigate screen flickering, see:
    # https://wiki.archlinux.org/title/intel_graphics#Screen_flickering
    # https://github.com/linux-surface/linux-surface/issues/862
    "i915.enable_psr=0"
  ];
  # Add the kernel modules such that we have a working keyboard for the 
  # LUKS full disk encryption.
  # https://github.com/linux-surface/linux-surface/wiki/Disk-Encryption
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

  networking.hostName = "Ruby";

  # Enable touchpad support 
  services.xserver.libinput.enable = true;

  # Additional Packages
  environment.systemPackages = with pkgs; [
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Don't touch this

}

