{config, pkgs, ...}: {
  nix.settings.trusted-users = [ "noah" ];

  users.users.noah = {
    extraGroups = [ "wheel" "networkmanager" "audio" "pipewire" "uinput" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;
}
    
