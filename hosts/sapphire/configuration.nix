# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{

  # Sapphire Imports
  imports = [
    ./../../nixosModules
  ];

  # AMD Proprietary drivers
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable for xserver
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelParams = [
    "video=DP-1:2560x1440@75"
    "video=DP-2:2560x1440@75"
  ];

  # opengl - renamed to graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # QMK
  hardware.keyboard.qmk.enable = true;

  modules = {
    steam.enable = true;
    docker.enable = true;
    obs.enable = true;
    postgre.enable = true;
    lsp.enable = true;
    js-dev.enable = true;
    csharp.enable = true;
    vm.enable = true;
  };

  grub = {
    enable = true;
  };

  networking.hostName = "Sapphire";

  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    amdctl
    amdgpu_top
    microcodeAmd
    edgetpu-compiler
    clinfo

    xorg.xhost
    ethtool # used to set up wol
  ];

  stylix.image = /home/noah/images/wallpapers/sunset_city.jpg;
  
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

