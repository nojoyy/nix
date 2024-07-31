{ pkgs, lib, config, ... }:

let module = config.modules.zsh;

in {

  options = {
    modules.zsh.enable = lib.mkEnableOption "enable zsh config";
  };

  config = lib.mkIf module.enable {
    xdg.configFile."zsh/.zshrc".source = ./.zshrc;

    programs.zsh = {
      enable = true;
      envExtra = "ZDOTDIR=/home/noah/.config/zsh/"; 
    };
  };
}
