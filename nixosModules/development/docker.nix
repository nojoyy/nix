{ pkgs, lib, config, ... }:

let module = config.modules.docker;

in {
  options = {
    modules.docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf module.enable {
    virtualisation.docker.enable = true;
    users.users.noah.extraGroups = [ "docker" ];
  };
}
