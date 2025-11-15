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

    services.postgresql = {
      enable = lib.mkDefault true;
      # initialScript = pkgs.writeScript "init.sql" ''
      #   CREATE USER shiori;
      #   CREATE DATABASE shiori OWNER shiori;
      # '';
    };

    # Enable and Setup Shiori
    services.shiori = {
      enable = true;
      package = pkgs.shiori;
      port = 6453;
      address = domain;
      databaseUrl = "postgres:///shiori?host=/run/postgresql";
    };
  };
}
