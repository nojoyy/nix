{ pkgs, lib, config, ... }:

let
  shioriDomain = "links.noahjoyner.com";
  giteaDomain = "git.noahjoyner.com";
in {

  options = {
    modules.shiori.enable = lib.mkEnableOption "Enable Shiori";
    modules.gitea.enable = lib.mkEnableOption "Enable Gitea with Postgre Support";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.modules.shiori.enable || config.modules.gitea.enable) {
      services.postgresql = {
        enable = lib.mkDefault true;
        authentication = ''
  # TYPE  DATABASE        USER            ADDRESS                 METHOD
  local   all             all                                     peer
  local   all             shiori                                  md5
  host    all             shiori          127.0.0.1/32            md5
  host    all             all             127.0.0.1/32            md5
  host    all             all             ::1/128                 md5
        '';
        ensureDatabases =
          (lib.optional config.modules.gitea.enable "gitea") ++
          (lib.optional config.modules.gitea.enable "shiori");
        ensureUsers = [
          (lib.mkIf config.modules.gitea.enable {
            name = "gitea";
          })
          (lib.mkIf config.modules.shiori.enable {
            name = "shiori";
          })
        ];
      };
    })

    (lib.mkIf config.modules.shiori.enable {
      services.shiori = {
        enable = true;
        package = pkgs.shiori;
        port = 6453;
        databaseUrl = "postgres://shiori@/shiori?host=/run/postgresql&sslmode=disable";
      };
    })

    (lib.mkIf config.modules.gitea.enable {
      services.gitea = {
        enable = true;
        package = pkgs.gitea;

        settings = {
          server = {
            HTTP_PORT = 2000;
            ROOT_URL = "https://${giteaDomain}";
            DOMAIN = giteaDomain;
            SSH_DOMAIN = giteaDomain;
            SSH_PORT = 22;
            DISABLE_SSH = false;
          };

          service = {
            DISABLE_REGISTRATION = true;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
          };

          oauth2 = {
            ACCESS_TOKEN_EXPIRATION_TIME = 86400;
          };
        };

        database = {
          type = "postgres";
          host = "127.0.0.1:5432";
          name = "gitea";
          user = "gitea";
          password = "gitPass";
        };
      };
    })
  ];
}
