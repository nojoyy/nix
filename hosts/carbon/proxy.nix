{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts = {
      "git.noahjoyner.com" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        serverName = "git.example.com";
        locations."/" = {
          proxyPass = "http://localhost:3000";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';  
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
