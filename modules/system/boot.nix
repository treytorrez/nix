{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      #      theme = "rings";
      #      themePackages = with pkgs; [
      #        (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
      #      ];
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
