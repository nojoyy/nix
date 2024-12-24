{ config, pkgs, lib, ... }:

{

  # Default Modules
  imports = [
    ./hyprland
    ./fm
    ./emacs
    ./zsh
    ./waybar
  ];
  
  # General Home Manager Config
  home.username = "noah";

  #General Packages
  home.packages = with pkgs; [ 
    # Desktop
    keepassxc
    libreoffice-qt
    filezilla
    
    # Misc Utils
    gimp
   ];

  # wlogout
  programs.wlogout.enable = true;

  # Clear tofi cache to update desktop entries
  home.activation = {
    # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
    regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                       tofi_cache=${config.xdg.cacheHome}/tofi-drun
                       [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
                       '';
  };

  # Session Variables
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/noah/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    EDITOR = "emacsclient";
    GTK_USE_PORTAL = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
