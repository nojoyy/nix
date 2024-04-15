{ config, pkgs, ... }:

{
  # Install lxqt polkit
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
  ];
  
  # Enable polkit
  security.polkit.enable = true;
}
