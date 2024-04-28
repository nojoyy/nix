{ config, pkgs, ... }:
    
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap
  services.xserver.xkb.layout = "us";

  environment.systemPackages = with pkgs; [
    # Window manager
    hyprpaper
    dunst
    tofi
    waybar
    swaylock

    # Terminal
    foot
    neofetch

    # ICC
    displaycal

    # GNOME Menus/Icons
    gnome-menus
    gnome.adwaita-icon-theme
  ];

  # Enable swaylock with pam
  security.pam.services.swaylock = {};

  # Enable Hyprland
  programs.hyprland.enable = true;
}
