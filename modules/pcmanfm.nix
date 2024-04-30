{config, pkgs, ...}:

{
  home.packages = with pkgs; [
    pcmanfm
    lxmenu-data # suggested appications
    shared-mime-info # more file types
  ];
}
  
