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
    ./minecraft.nix
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
  
  # Nix Helper - cli utility for streamlined rebuilds
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

  # ssh
  services.openssh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [ fira-code font-awesome nerd-fonts.fira-code fira ];

  # System level packages
  environment.systemPackages = with pkgs; [
    vlc
    cachix

    xdg-desktop-portal

    lmms

    libinput

    libnotify

    pcmanfm

    hugo

    gnupg
    pass

    pinentry-curses

    git-credential-manager
  ];

  # xdg.portal.config.common.default = "*";

  # setup hyprland
  programs.hyprland = {
    enable = true;
  };

  # setup xserver (for legacy application to fallback from wayland)
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # keyboard remapping service
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
        caps)
    
      (deflayermap (default-layer)
        caps (tap-hold 100 75 esc lctrl))
    '';
  };
}
