{ config, pkgs, ...}:

{
  # Enable OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # Enable portal in home session
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
  
}
