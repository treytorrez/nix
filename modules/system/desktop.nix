{ pkgs,  ... }:
{
  # Display managers
  # services.displayManager.sddm.enable = true;

  # Desktop environments
  # services.desktopManager.plasma6.enable = true;
  # services.desktopManager.cosmic.enable = true;
  # programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.lxqt.enable = true;
    windowManager.i3.enable = true;
    displayManager.lightdm = {
      enable = true;
    
      # Setting gtk as the greeter
      greeters.gtk.enable = true;
    
      # Example of having background as a particular color
      background = "#282828";
    
      # Example of the default image background (must be an absolute path)
      #background = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath;
    
    };
    xkb = {
        layout = "us";
        variant = "";
    };


  };



  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.fwupd.enable = true; # TODO: I really do not know where to put this
}
