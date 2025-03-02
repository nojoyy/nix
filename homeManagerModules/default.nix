{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland
    ./emacs
    ./waybar
    ./fm
  ];
  
  home.username = "noah";

  home.packages = with pkgs; [ 
    keepassxc
    libreoffice-qt
    filezilla
    gimp

    # spell checking
    hunspell
    hunspellDicts.en_US
   ];

  # wlogout logout manager
  programs.wlogout.enable = true;

  # clear tofi cache to update desktop entries
  home.activation = {
    # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
    regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                       tofi_cache=${config.xdg.cacheHome}/tofi-drun
                       [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
                       '';
  };


  # env var setup
  home.sessionVariables = {
    EDITOR = "emacsclient";
    GTK_USE_PORTAL = "1";
  };

  # let home manager install and manage itself.
  programs.home-manager.enable = true;
}
