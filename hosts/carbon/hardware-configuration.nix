# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ohci_pci" "ehci_pci" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ "overlay" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/318f775d-ef9c-498f-b745-90efefa93108";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6770-065A";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/mnt/tier-two" =
    { device = "/dev/disk/by-uuid/1ace927e-f0e6-4e17-be4d-d29f2abdb806";
      fsType = "ext4";
    };

  fileSystems."/mnt/tier-one" =
    { device = "/dev/disk/by-uuid/ed1e5881-de21-4fb0-ae4c-a75945e7b06b";
      fsType = "ext4";
    };

  fileSystems."/mnt/media-pool" =
    {
      device = "overlay";
      fsType = "overlay";
      options = [
        "lowerdir=/mnt/tier-two"
        "upperdir=/mnt/tier-one"
        "workdir=/mnt/work"
      ];
    };

  fileSystems."/mnt/work" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "size=2000M" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/46e93d61-00ee-4cd2-b0bb-4f1a38bbe835"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
