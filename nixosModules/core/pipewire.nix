{ config, pkgs, ...}:

{
  # Enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # UPower
  services.upower.enable = true;

  # Bluetooth setup
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
