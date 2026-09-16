{ pkgs, ... }:
{
  systemd.user = {
    timers = {
      "automatic-nix-store-optimization" = {
        Unit.Description = "Weekly deduplication of the Nix store with `nix store optimize`";
        Timer = {
          OnCalendar = "Mon *-*-* 04:00:00";
          Persistent = true;
        };
      };
    };

    services = {
      "nix-store-optimize" = {
        Unit.Description = "Run `nix store optimize`";
        Service = {
          Type = "exec";
          ExecStart =
            let
              safeStoreOptimize = pkgs.writeShellScript "safe-store-optimise" ''
                ${pkgs.libnotify}/bin/notify-send \
                'Beginning Nix store optimization' \
                'Expect slowdowns, store optimization is computationally expensive';

                nix store optimise
              '';
            in
            "${safeStoreOptimize}";

        };
      };
    };
  };
}
