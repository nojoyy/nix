{ pkgs, lib, config, ... }:

let module = config.modules.minecraft;

in {

  options = {
    modules.minecraft.enable = lib.mkEnableOption "enable minecraft";
  };

  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}
 
