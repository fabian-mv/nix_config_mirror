{
  lib,
  pkgs,
  ...
}:
with lib; {
  systemd.user.tmpfiles.rules = [
    "d %t/tmp 0700 fabian fabian 24h"
  ];
}
