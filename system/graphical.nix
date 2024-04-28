{ config, pkgs, ... }:
    
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap
  services.xserver.xkb.layout = "us";

  environment.systemPackages = with pkgs; [
    # ICC
    displaycal
  ];
}
