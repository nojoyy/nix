{ pkgs, lib, config, ... }:

let module = config.modules.services.media;

in {

  options = {
    modules.services.media.enable = lib.mkEnableOption "enable media services";
  };

  config = lib.mkIf module.enable {
    services.postgre = {
      enable = lib.mkDefault true;
      initialScript = pkgs.writeScript ''
        CREATE USER jellyfin WITH PASSWORD jellyPass;
        CREATE DATABASE jellyfin WITH OWNER jellyfin;
      '';
    };

    services.jellyfin = {
      enable = lib.mkDefault true;
      openFirewall = true;

      # Database config
      database = {
        type = "postgresql";
        server = "localhost";
        databse = "jellyfin";
        user = "jellyfin";
        password = "jellyPass";
      };
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
