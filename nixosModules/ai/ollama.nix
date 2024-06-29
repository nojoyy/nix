{ pkgs, config, lib, ... }:

let

  cfg = config.ollama;
  ollamaPackage = pkgs.ollama.override {
    acceleration = "rocm";
    linuxPackages = config.boot.kernelPackages // {
      nvidia_x11 = config.hardware.nvidia.package; # not sure if needed
    };
  };

in
{

  options = {
    ollama = {
      enable = lib.mkEnableOption "ollama server for local llm";
    };
  };
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      ollamaPackage
    ];
  };
}
