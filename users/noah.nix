{lib, pkgs, ...}: {
  nix.settings.trusted-users = [ "noah" ];

  users.users.noah = {
    extraGroups = [ "wheel" "networkmanager" "audio" "pipewire" "uinput" ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  # some issue with uinput https://discourse.nixos.org/t/warning-not-applying-gid-change-of-group-uinput-989-327-in-etc-group/57652
  users.groups.uinput.gid = lib.mkForce 993;

  programs.fish.enable = true;
}
    
