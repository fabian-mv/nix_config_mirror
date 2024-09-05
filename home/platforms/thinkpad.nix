{
  config.local = {
    nixos = false;

    display = {
      "0" = "eDP-1";
      "1" = null;

      autorandrProfile = {
        fingerprint = {
          eDP-1 = "00ffffffffffff000dae0a1400000000291d0104a51f11780328659759548e271e505400000001010101010101010101010101010101363680a0703820403020a60035ad10000018000000fe004e3134304843412d4541450a20000000fe00434d4e0a202020202020202020000000fe004e3134304843412d4541450a200002";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            rate = "60.0";
            rotate = "normal";
          };
        };
      };
    };
  };
}
