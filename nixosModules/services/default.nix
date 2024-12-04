{ pkgs, lib, config, ... }:

let homeDir = config.users.users."noah".home;

in {
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./open-webui.nix
    ./matrix.nix
  ];

  environment.systemPackages = with pkgs; [
    hugo
  ];

  systemd.services.hugo = {
    description = "Hugo Blog Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.hugo}/bin/hugo serve -s ${homeDir}/blog";
      Restart = "on-failure";
      RestartSec = 5;
    };

    serviceConfig.User = "noah";
  };
}
