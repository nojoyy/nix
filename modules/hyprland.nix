{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Window manager
    hyprpaper
    hyprlock
    dunst
    tofi
    waybar

    # Terminal
    foot
    neofetch

    # GNOME Menus/Icons
    gnome-menus
    gnome.adwaita-icon-theme

    imagemagick
  ];

  # Enable Hyprland
  programs.hyprland.enable = true;
}
