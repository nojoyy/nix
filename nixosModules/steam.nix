{ pkgs, lib, config, ... }:

let module = config.modules.steam;

in {

  options = {
    modules.steam.enable = lib.mkEnableOption "enable steam";
  };

  config = lib.mkIf module.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    environment.systemPackages = with pkgs; [
      lutris
      mangohud
      protonup-qt
    ];
  };
}
 
