{ ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts = {
      # gitea instance
      "git.noahjoyner.com" = {
        enableACME = true;
        locations."/" = {
          extraConfig = ''
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
          '';
          proxyPass = "http://localhost:2000";
        };
      };

      # jellyfin instance
      "media.noahjoyner.com" = {
        enableACME = true;
        locations."/" = {
          # Additional headers for better security and operations
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # WebSocket support for Jellyfin (for Live Streaming, dashboard, etc.)
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            client_max_body_size 0;  # Allow uploads/downloads with no size limits
            proxy_buffering off;     # Disable buffering for proxied requests
          '';
          proxyPass = "http://localhost:8096";
        };
      };

      "blog.noahjoyner.com" = {
        enableACME = true;
        serverName="blog.noahjoyner.com";
        root = "/home/noah/blog/public";
        locations."/" = {
          tryFiles = "$uri $uri/ =404";
        };
      };

      # vaultwarden server
      "vault.noahjoyner.com" = {
        enableACME = true;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        '';
          proxyPass = "http://localhost:8222";
        };
      };

      # open webui
      "chat.noahjoyner.com" = {
        enableACME = true;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_http_version 1.1;
            proxy_buffering off;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Accel-Internal /internal-nginx-static-location;
        '';
          proxyPass = "http://localhost:7391";
        };
      };

      # shiori
      "links.noahjoyner.com" = {
        enableACME = true;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        '';
          proxyPass = "http://localhost:6453";
        };
      };

      # apis
      # "api.noahjoyner.com" = {
      #   enableACME = true;
      #   locations."/" = {
      #     extraConfig = ''
      #       proxy_set_header Host $host;
      #       proxy_set_header X-Real-IP $remote_addr;
      #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #       proxy_set_header X-Forwarded-Proto $scheme;
      #   '';
      #     proxyPass = "http://192.168.0.142:11434/";
      #   };
      # };

      # matrix
    #   "www.hawktuah.lifestyle" = {
    #     enableACME = true;
    #     locations."/" = {
    #       proxyPass = "http://localhost:8008";
    #       proxyWebsockets = true;
    #     };
    #     locations."/federation" = {
    #       proxyPass = "http://localhost:8448";
    #     };
    #   };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "njoydev@proton.me";
      dnsProvider = "cloudflare";
      group = "nginx";
      environmentFile = "/home/noah/cloudflare";
    };
    certs = {
      "noahjoyner.com" = {
        domain = "*.noahjoyner.com";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
}
