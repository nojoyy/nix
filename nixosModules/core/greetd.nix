{ pkgs, lib, config, ... }:

{
  options = {
    greetd.enable = lib.mkEnableOption "enable greetd dispay manager";
  };

  config = lib.mkIf config.greetd.enable {
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
    '';
  };
}
