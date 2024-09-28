{ ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts = {
      # gitea instance
      "git.noahjoyner.com" = {
        enableACME = true;
        # forceSSL = true;
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

      # webpage
      "www.noahjoyner.com" = {
        enableACME = true;   # Automatically manage SSL (using Let's Encrypt).
        # forceSSL = true;     # Redirect HTTP to HTTPS.
        
        root = "/home/noah/www/default/";
        
        # Serve static files
        locations."/".extraConfig = ''
          try_files $uri $uri/ =404;
        '';
      };
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
