{ pkgs, ... }:
{
  services.fnott = {  # TODO: do comparison with `mako`. fnott appears like it can do a bit more *IF* configured... like at all. i need to do a little configuring. clicking on notifs doesn't redirect me to apps like I would expect.
    # TODO: notifs need a timeout, maybe no timeout for urgent. 
    # TODO: styling, may already be done by stylix. 
    enable = true;
    settings = {
    main = { selection-helper="mew"; }; # TODO: is this referencing the pkg correctly? does it need to link to `pkgs.mew` 

      low = {
      };

      normal = {
      };

      critical = {
      };
    };
  };
}
