{ pkgs, ...}:

{
  imports = [
    ./../../users/noah.nix
    ./proxy.nix
    ./../../nixosModules/services/gitea.nix
    ./../../nixosModules/services/jellyfin.nix
  ];

  system.stateVersion = "23.11";

  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    hugo
  ];

  modules = {
    gitea.enable = true;
    services.media.enable = true;
  };

  # Samba Setup
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
      };
      "personal" = {
        "path" = "/home/noah/share";
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
    allowPing = true;
  };
}
