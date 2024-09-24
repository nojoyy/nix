{ pkgs, ...}:

{
  imports = [
    ./../../users/noah.nix
    ./proxy.nix
    ./../../nixosModules/services/gitea.nix
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

  modules = {
    gitea.enable = true;
  };

  # Samba Setup
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
      };
      "basic" = {
        "path" = "/mnt/tier-zero";
        "valid users" = "noah";
        "browseable" = "yes";
        "writeable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "comment" = "Carbon";
        "force user" = "noah";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 ];
    allowPing = true;
  };
}
