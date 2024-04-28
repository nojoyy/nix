{ config, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    autoNumlock = true;
    theme = "abstractdark";
  };
  
  environment.systemPackages = let themes = pkgs.callPackage ./sddm-themes.nix {}; in [ themes.abstractdark ];
  
}
    
