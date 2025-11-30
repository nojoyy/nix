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
      rocmPackages.clr.icd
    ];
  };

  networking.firewall.allowedTCPPorts = [ 5173 3000 ];

  # QMK
  hardware.keyboard.qmk.enable = true;

  # Module Toggling
  modules = {
    emacs.enable = true;

    ollama.enable = true;
    
    steam.enable = true;
    minecraft.enable = true;

    docker.enable = true;
    obs.enable = true;
    lsp.enable = true;
    js-dev.enable = true;
    vm.enable = true;
    postgresql.enable = true;
    greetd.enable = true;
    sddm.enable = false;

    stylix.enable = true;
  };

  grub = {
    enable = true;
    useOSProber = true;
  };

  networking = {
   hostName = "Sapphire"; 
   interfaces = {
     enp42s0 = {
       wakeOnLan.enable = true;
     };
   };
   firewall = {
     allowedUDPPorts = [ 9 ];
    };
  };

  services.hardware.openrgb.enable = true;

  # adb
  programs.adb.enable = true;
  users.users.noah.extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [
    amdctl
    amdgpu_top
    microcode-amd
    edgetpu-compiler
    clinfo

    fontconfig

    hydroxide

    element-desktop
    
    xorg.xhost
    ethtool # used to set up wol

    sqlite
    sqlitebrowser

    inkscape
    krita

    guitarix
    rakarrack

    discord
    
    ledger
  ];

  hardware.opentabletdriver.enable = true;
    
  system.stateVersion = "23.11"; # Don't touch this
}

