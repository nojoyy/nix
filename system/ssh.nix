{ config, pkgs, ... }: {

  # Enable openssh daemon
  services.openssh.enable = true;
}
