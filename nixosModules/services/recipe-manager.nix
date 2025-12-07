{ pkgs, lib, config, recipe-manager, ... }:

let
  cfg = config.modules.recipe-manager;
  domain = "recipes.noahjoyner.com";

  # Use Nix-built packages from flake input
  backendBinary = "${recipe-manager.packages.${pkgs.system}.backend}/bin/recipe-manager-backend";
  frontendBuild = "${recipe-manager.packages.${pkgs.system}.frontend}";

in {

  options = {
    modules.recipe-manager = {
      enable = lib.mkEnableOption "Enable Recipe Manager";

      port = lib.mkOption {
        type = lib.types.port;
        default = 3001;
        description = "Port for the Recipe Manager backend API";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # PostgreSQL database setup
    services.postgresql = {
      enable = lib.mkDefault true;
      ensureDatabases = [ "recipe_manager" ];
      ensureUsers = [{
        name = "recipe_manager";
        ensureDBOwnership = true;
      }];

      # Allow local trust authentication for recipe_manager user
      authentication = lib.mkOverride 10 ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
      '';
    };

    # Create system user
    users.users.recipe-manager = {
      isSystemUser = true;
      group = "recipe-manager";
      home = "/var/lib/recipe-manager";
      createHome = true;
      description = "Recipe Manager service user";
    };

    users.groups.recipe-manager = {};

    # Backend systemd service
    systemd.services.recipe-manager-backend = {
      description = "Recipe Manager API Backend";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        DATABASE_URL = "postgresql://recipe_manager@localhost/recipe_manager";
        RUST_LOG = "info";
      };

      serviceConfig = {
        Type = "simple";
        User = "recipe-manager";
        Group = "recipe-manager";
        WorkingDirectory = "/var/lib/recipe-manager";

        # Use Nix-built binary from flake
        ExecStart = backendBinary;

        Restart = "on-failure";
        RestartSec = "10s";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/lib/recipe-manager" ];
      };
    };

    # Nginx virtual host
    services.nginx.virtualHosts."${domain}" = {
      enableACME = true;
      forceSSL = true;

      # Serve frontend static files
      root = frontendBuild;

      locations."/" = {
        # SPA fallback - try file, then directory, then index.html for client-side routing
        tryFiles = "$uri $uri/ /index.html";
        extraConfig = ''
          # Cache static assets aggressively
          add_header Cache-Control "public, max-age=31536000, immutable";
        '';
      };

      # Proxy API requests to Rust backend
      locations."/api/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      # Health check endpoint
      locations."/health" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        extraConfig = ''
          access_log off;
        '';
      };

      # Don't cache HTML (allows SPA updates without cache issues)
      locations."= /index.html" = {
        extraConfig = ''
          add_header Cache-Control "no-cache, no-store, must-revalidate";
        '';
      };
    };
  };
}
