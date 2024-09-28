{ pkgs, lib, config, ... }:

let module = config.modules.services.media;

in {

  options = {
    modules.services.media.enable = lib.mkEnableOption "enable media services";
  };

  config = lib.mkIf module.enable {
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
  };
}
