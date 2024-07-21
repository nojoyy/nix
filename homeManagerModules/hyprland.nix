{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [
    # Window manager
    swww
    hyprlock
    dunst
    tofi
    waybar

    # Image Viewer
    qimgv

    # GNOME Menus/Icons
    gnome-menus
    gnome.adwaita-icon-theme
  ];

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    # pull from existing config
    extraConfig = ''
      source = ~/.config/hypr/external.conf
      '';
  };

  # Let swww control wallpapers
  services.hyprpaper.enable = lib.mkForce false;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
