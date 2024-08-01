{ pkgs, lib, config, ... }:

let
  module = config.modules.waybar;

in {
  options = {
    modules.waybar.enable = lib.mkEnableOption "enable waybar config";
  };

  config = lib.mkIf module.enable {
    programs.waybar = {
      systemd.enable = true;
      enable = true;
      style = lib.mkForce ./style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          
          modules-left = [ "hyprland/mode" "hyprland/workspaces" "hyprland/window"];
          modules-right = [
		        "pulseaudio"
		        "network"
		        "memory"
		        "cpu"
		        "temperature"
		        "clock#date"
		        "clock#time"
          ];
          
          "clock#time" = {
            interval = 10;
            format = "{:%H:%M}";
            tooltp = false;
          };
          
          "clock#date" = {
            interval = 20;
            format = "{:%e %B %Y}";
            tooltip = false;
          };
          
          "cpu" = {
            interval = 5;
            format = " {usage}%";
            format-alt = " {load}";
            states  = {
              warning = 70;
              critical = 90;
            };
            tooltip = false;
          };
          
          
          "memory" = {
            interval = 5;
            format = " {used:0.1f}G/{total:0.1f}G";
            states = {
              warning = 70;
              critical = 90;
            };
            tooltip = false;
          };
          
          "network" = {
            interval = 5;
            format-wifi = " {essid} ({signalStrength}%)";
            format-ethernet = " {ifname}";
            format-disconnected = "No connection";
            format-alt = " {ipaddr}/{cidr}";
            tooltip = false;
          };
          
          "hyprland/mode" = {
            format = "{}";
            tooltip = false;
          };
          
          "hyprland/window" = {
            format = "{}";
            max-length = 20;
            tooltip = false;
          };
          
          "hyprland/workspaces" = {
            disable-scroll-wraparound = true;
            smooth-scrolling-threshold = 4;
            enable-scroll-bar = true;
            format = "{name}";
          };
          
          "pulseaudio" = {
            format = "{icon}   {volume}%";
            format-bluetooth = "{icon}  {volume}%"; 
            format-muted = "";
		        format-icons = {
			        headphone = "";
			        hands-free = "";
			        headset = "";
			        phone = "";
			        portable = "";
			        car = "";
			        default = ["" ""];
		        };
            
		        scroll-step = 1;
		        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
		        tooltip = false;
          };
          
          "temperature" = {
		        critical-threshold = 90;
		        interval = 5;
		        format = "{icon} {temperatureC}°";
		        format-icons = [
			        ""
			        ""
			        ""
			        ""
			        ""
		        ];
		        tooltip = false;
          };
        };
      };
    };
  };       
}
