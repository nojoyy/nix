{ pkgs, lib, config, ... }:

let module = config.modules.gitea;
  domain = "git.noahjoyner.com";

in {

  options = {
   modules.gitea = {
     enable = lib.mkEnableOption "Enable Gitea with Postgre Support";
   }; 
  };

  config = lib.mkIf module.enable {

    # Enable PostgreSQL and Create Gitea DB
    services.postgresql = {
      enable = lib.mkDefault true;
      initialScript = pkgs.writeScript "init.sql" ''
        CREATE USER gitea WITH PASSWORD gitPass;
        CREATE DATABASE gitea OWNER gitea;
      '';
    };

    # Enable and Setup Gitea
    services.gitea = {
      enable = true;
      package = pkgs.gitea;

      settings = {
        server = {
          HTTP_PORT = 2000;
          ROOT_URL = "https://${domain}";
          DOMAIN = domain;
          SSH_DOMAIN = domain;
          SSH_PORT = 22;
          DISABLE_SSH = false;
        };

        # Disable Public Registration
        service = {
          DISABLE_REGISTRATION = true;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
        };
      };

      # Database Setup
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
