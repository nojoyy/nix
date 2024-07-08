{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Window manager
    hyprpaper
    hyprlock
    dunst
    tofi
    waybar

    # Image Viewer
    qimgv

    # Terminal
    foot
    neofetch
    fastfetch

    # GNOME Menus/Icons
    gnome-menus
    gnome.adwaita-icon-theme
  ];

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # pull from existing config
    extraConfig = ''
      source = ~/.config/hypr/external.conf
      '';
  };

  stylix.targets.hyprland.enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
