{ config, pkgs, ... }:

{
  # Install lxqt polkit (for hyprland)
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
  ];
  
  # Enable polkit (policy management)
  security.polkit.enable = true;
}
