{ pkgs, lib, config, sveltekit-app, ... }:

let myApp = sveltekit-app.packages.${pkgs.system}.sveltekit-app;

in {
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./open-webui.nix
    ./matrix.nix
    ./shiori.nix
  ];

  systemd.services.sveltekit-app = {
    description = "SvelteKit App (Node Adapter)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_24}/bin/node ${myApp}/lib/node_modules/sveltekit-app/build";
      WorkingDirectory = myApp;
      Restart = "always";
      Environment = [
        "NODE_ENV=production"
        "PORT=3000"
      ];
    };
  };
}
