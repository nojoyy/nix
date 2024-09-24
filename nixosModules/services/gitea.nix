{ pkgs, lib, config, ... }:

let module = config.modules.gitea;

in {

  options = {
   modules.gitea = {
     enable = lib.mkEnableOption "Enable Gitea with Postgre Support";
   }; 
  };

  config = lib.mkIf module.enable {
    services.postgresql = {
      enable = lib.mkDefault true;
      initialScript = pkgs.writeScript "init.sql" ''
        CREATE USER gitea WITH PASSWORD gitPass;
        CREATE DATABASE gitea OWNER gitea;
      '';
    };

    services.gitea = {
      enable = true;

      settings.server = {
        HTTP_PORT = 2000;
      };

      database = {
        type = "postgres";
        host = "127.0.0.1:5432";
        name = "gitea";
        user = "gitea";
        password = "gitPass";
      };
    };
  };
}
