{
  config,
  pkgs,
  lib,
  ...
}: {
  services.picom = {
    fade = true;
    fadeSteps = [0.1 0.1];
    fadeDelta = 10;
    settings = {
      animations = [
        {
          triggers = [
            "open"
            "show"
          ];

          preset = "appear";
          duration = "1";
        }
        {
          triggers = [
            "close"
            "hide"
          ];

          preset = "disappear";
          duration = "1";
        }
        {
          triggers = [
            "geometry"
          ];
          preset = "geometry-change";
          duration = "1";
        }
      ];
    };
  };
}
