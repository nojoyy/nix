{ pkgs, lib, config, site, ... }:

let
  cfg = config.modules.site;
  domain = "noahjoyner.com";

  # Use Nix-built package from flake input
  siteBuild = "${site.packages.${pkgs.system}.default}";

in {

  options = {
    modules.site = {
      enable = lib.mkEnableOption "Enable noahjoyner.com site";

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port for the SvelteKit Node.js server";
      };

      postsDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/var/posts";
        description = "Directory containing blog posts (markdown files)";
      };

      enableNginx = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable nginx reverse proxy with SSL";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # Ensure blog posts directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.postsDirectory} 0755 site site -"
    ];

    # Create system user
    users.users.site = {
      isSystemUser = true;
      group = "site";
      home = "/var/lib/site";
      createHome = true;
      description = "Site service user";
    };

    users.groups.site = {};

    # SvelteKit Node.js systemd service
    systemd.services.site = {
      description = "noahjoyner.com - SvelteKit website";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        NODE_ENV = "production";
        PORT = toString cfg.port;
        # Posts directory is read at runtime by blog routes
        POSTS_DIR = cfg.postsDirectory;
      };

      serviceConfig = {
        Type = "simple";
        User = "site";
        Group = "site";
        WorkingDirectory = siteBuild;

        # Use Nix-built site from flake
        ExecStart = "${pkgs.nodejs}/bin/node ${siteBuild}/index.js";

        Restart = "on-failure";
        RestartSec = "10s";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadOnlyPaths = [ cfg.postsDirectory ];
      };
    };

    # Nginx virtual host (optional reverse proxy)
    services.nginx.virtualHosts."${domain}" = lib.mkIf cfg.enableNginx {
      # Use the wildcard certificate defined in proxy.nix
      useACMEHost = "noahjoyner.com";
      forceSSL = true;

      # Also respond to www subdomain
      serverAliases = [ "www.${domain}" ];

      # Proxy all requests to Node.js backend
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # Cache static assets (SvelteKit serves with cache headers)
          proxy_cache_bypass $http_upgrade;
          proxy_buffering on;
        '';
      };

      # Optional: Health check endpoint (if you add one)
      # locations."/health" = {
      #   proxyPass = "http://127.0.0.1:${toString cfg.port}";
      #   extraConfig = ''
      #     access_log off;
      #   '';
      # };
    };
  };
}
