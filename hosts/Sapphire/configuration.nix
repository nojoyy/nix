# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  # Sapphire Imports
  imports = [
    ./../../nixosModules
  ];

  # Nintendo Hardware
  boot.extraModprobeConfig = ''
    options hid_nintendo hid-nintendo.quirks=0x0
  '';

  hardware.enableAllFirmware = true;

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

  # Module Toggling
  modules = {
    ollama.enable = true;
    steam.enable = true;
    docker.enable = true;
    obs.enable = true;
    lsp.enable = true;
    js-dev.enable = true;
    csharp.enable = true;
    vm.enable = true;
    postgresql.enable = true;
    emacs.enable = true;
    sddm.enable = true;

    stylix.enable = true;
  };

  grub = {
    enable = true;
    useOSProber = true;
  };

  networking.hostName = "Sapphire";

  services.hardware.openrgb.enable = true;

  # adb
  programs.adb.enable = true;
  users.users.noah.extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [
    amdctl
    amdgpu_top
    microcodeAmd
    edgetpu-compiler
    clinfo

    fontconfig

    hydroxide

    element-desktop
    
    xorg.xhost
    ethtool # used to set up wol

    opentabletdriver
    inkscape
    krita
    
    ledger
  ];

  system.stateVersion = "23.11"; # Don't touch this
}

