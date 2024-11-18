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

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "~/nix/homeManagerModules/hyprland/config/hyprland.conf"
        "~/nix/homeManagerModules/hyprland/config/monitors.conf"
      ];
    };
  };

  # Let swww control wallpapers
  services.hyprpaper.enable = lib.mkForce false;

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  stylix.targets.hyprland.enable = false;
}
