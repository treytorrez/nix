{ ... }:
{
  # Display managers
  services.displayManager.sddm.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Desktop environments
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = true;
  programs.hyprland.enable = true;

  services.system76-scheduler.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
