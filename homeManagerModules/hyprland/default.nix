{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [
    # Window manager
    swww
    hyprlock
    dunst
    tofi

    # Image Viewer
    qimgv

    # GNOME Menus/Icons
    gnome-menus
    adwaita-icon-theme
  ];

  # Let swww control wallpapers
  services.hyprpaper.enable = lib.mkForce false;

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

}
