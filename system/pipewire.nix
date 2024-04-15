{ config, pkgs, ...}:

{
  # Enable pipewire
  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth setup
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
