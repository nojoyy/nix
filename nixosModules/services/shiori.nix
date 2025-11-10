{ pkgs, lib, config, ... }:

let module = config.modules.shiori;
  domain = "links.noahjoyner.com";

in {

  options = {
   modules.shiori = {
     enable = lib.mkEnableOption "Enable Shiori";
   }; 
  };

  config = lib.mkIf module.enable {

    # Enable and Setup Shiori
    services.shiori = {
      enable = true;
      package = pkgs.shiori;
      port = 6453;
      address = domain;
    };
  };
}
