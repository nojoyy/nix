{ pkgs, lib, config, ... }:

let module = config.modules.greetd;

in {
  options = {
    modules.greetd.enable = lib.mkEnableOption "enable greetd dispay manager";
  };

  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [ greetd tuigreet ];
    
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd hyprland";
        };
      };
      useTextGreeter = true;
    };
  };
}
