{ config, pkgs, ... }:
{
  # 1. Enable Hyprland
  programs.hyprland.enable = true;
  services.upower.enable = true;
  services.tlp.enable = true;

  # 2. Enable LXQt (still required for the core desktop components)
  #services.xserver.desktopManager.lxqt.enable = true;

  # 3. Enable your display manager (SDDM)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

services.open-webui = {
    enable = true;
    port = 1234;
  };

  # 4. Install the Wayland session package
  #   environment.systemPackages = with pkgs; [
  #     lxqt.lxqt-wayland-session
  #   ];

  # 5. (Optional) Pre-set Hyprland as the compositor for LXQt
  # This removes the need to manually configure it via the GUI on first login.
  environment.etc."xdg/lxqt/session.conf".text = ''
    [Wayland]
    compositor=hyprland
  '';
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.fwupd.enable = true;
}
