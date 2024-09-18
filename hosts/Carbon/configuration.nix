{ pkgs, ...}:

{
  imports = [
    ./../../users/noah.nix
  ];

  system.stateVersion = "23.11";

  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRuZhMim1ysgzNXXNH98poyq55tYOOOynE+krGFxHbH noah@Sapphire"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}
