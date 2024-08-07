{ pkgs, lib, config, ... }:

{
  
  stylix = {
    enable = lib.mkDefault true;
    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";
    # base16Scheme = {
    #   base00 = "1C1E26";
    #   base01 = "232530";
    #   base02 = "2E303E";
    #   base03 = "6F6F70";
    #   base04 = "9DA0A2";
    #   base05 = "CBCED0";
    #   base06 = "DCDFE4";
    #   base07 = "E3E6EE";
    #   base08 = "E93C58";
    #   base09 = "E58D7D";
    #   base0A = "EFB993";
    #   base0B = "EFAF8E";
    #   base0C = "24A8B4";
    #   base0D = "DF5273";
    #   base0E = "B072D1";
    #   base0F = "E4A382";
    # };
    
    
    # font configuration
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        name = "FiraCode Nerd Font";
      };
      sansSerif = {
        package = pkgs.fira-sans;
        name = "Fira Sans";
        };
      serif = config.stylix.fonts.sansSerif;
      sizes = {
        terminal = 12;
        applications = 12;
        desktop = 10;
        popups = 12;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # enable home manager integration
    homeManagerIntegration.autoImport = true;
  };
}
  
