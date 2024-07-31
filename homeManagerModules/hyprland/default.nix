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
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
