{ pkgs, config, inputs, lib, ... }:

{
  # Additional Modules
  imports = [
    ./../users/noah.nix
    ./ai
    ./core
    ./development
    ./emacs.nix
    ./obs.nix
    ./steam.nix
    ./vm.nix
    ./stylix.nix
  ];

  # Enable chachix for hyprland   
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager.backupFileExtension = "~/.backup";

  # Add QEMU/VM Support
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.noah.extraGroups = [ "libvirtd" ];
  
  # Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/noah/nix/";
  };

  services.gvfs.enable = true;

  # Network Manager
  networking.networkmanager.enable = true; 

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fonts
  fonts.packages = with pkgs; [ fira-code font-awesome fira-code-nerdfont fira ];

  # System level package
  environment.systemPackages = with pkgs; [
    cmake
    vlc
    cachix

    xdg-desktop-portal

    lmms

    hunspell
    aspell
  ];

  xdg.portal.config.common.default = "*";

  # HYPRLAND
  programs.hyprland = {
    enable = true;
  };

  # ENABLE X-SERVER
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # KANATA
  services.kanata = {
    enable = true;
    keyboards.default.configFile = /home/noah/dotfiles/kanata/config.kbd;
  };

  # WAYDROID
  virtualisation.waydroid.enable = true;
  
  # EMACS DAEMON
  emacs.enable = lib.mkDefault true;
}
