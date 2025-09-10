{ pkgs, config, lib, ... }:

let

  module = config.modules.ollama;
  ollamaPackage = pkgs.ollama.override {
    acceleration = "rocm";
  };

in {

  options = {
      modules.ollama.enable = lib.mkEnableOption "ollama server for local llm";
  };
  
  config = lib.mkIf module.enable {

    systemd.services.ollama = {
      description = "Server for local large language models";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "%S/ollama";
        OLLAMA_HOST = "127.0.0.1";
        OLLAMA_MODELS = "/home/noah/.ollama/models";
        HSA_OVERRIDE_GFX_VERSION = "10.1.0";
      };
      serviceConfig = {
        ExecStart = "${lib.getExe ollamaPackage} serve";
      };
    };
    
    environment.systemPackages = [
      ollamaPackage
    ];

    networking.firewall = {
      allowedTCPPorts = [];
    };
  };
}
