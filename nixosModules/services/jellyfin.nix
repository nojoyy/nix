{ pkgs, lib, config, ... }:

let module = config.modules.media;

in {

  options = {
    modules.media.enable = lib.mkEnableOption "enable media services";
  };

  config = lib.mkIf module.enable {

    users.groups."media" = {
      name = "media";
      members = [ "jellyfin" "sonarr" "radarr" "jackett" "prowlarr" ];
    };

    services.jellyfin = {
      enable = lib.mkDefault true;
      openFirewall = true;
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
    };

    services.radarr = {
      enable = true;
      openFirewall = true;
    };

    services.jackett = {
      enable = true;
      openFirewall = true;
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

  };
}
