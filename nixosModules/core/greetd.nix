{ pkgs, lib, config, ... }:

let module = config.modules.greetd;

in {
  options = {
    modules.greetd.enable = lib.mkEnableOption "enable greetd dispay manager";
  };

  config = lib.mkIf module.enable {
    services.greetd = {
      enable = true;
      settings = {
        deault_session = {
          command = "${pkgs.hyprland}/bin/hyprland";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      hyprland
      fish
      bash
    '';
  };
}
