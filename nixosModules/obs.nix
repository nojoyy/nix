{ pkgs, lib, config, ... }:

let module = config.modules.obs;

in {
  options = {
    modules.obs.enable = lib.mkEnableOption "enable obs";
  };
  

  config = lib.mkIf module.enable {
    
    environment.systemPackages = [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs # wayland roots obs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })
    ];

    # Set up so OBS can access Virtual Camera
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    ''        ;
  };
}
