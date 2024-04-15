{ config, pkgs, ... }:

{
  # Network Manager
  networking.networkmanager.enable = true; 

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fonts
  fonts.packages = with pkgs; [ fira-code font-awesome fira-code-nerdfont];

  # System level package
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    cmake
    vlc
    gnome.adwaita-icon-theme
  ];
}
