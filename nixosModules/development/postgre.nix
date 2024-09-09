{ lib, config, pkgs, ... }:

let module = config.modules.postgre;

in {

  options = {
    modules.postgre.enable = lib.mkEnableOption "enable postgre";
  };

  config = lib.mkIf module.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "recipe-manager" ];
      authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    };
  };
}
