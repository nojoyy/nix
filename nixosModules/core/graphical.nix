{ ... }:

{
  # Install Xserver for legacy application
  # hyprland hooks into this
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
}
