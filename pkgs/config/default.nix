lib:
with lib; {
  android_sdk.accept_license = true;
  allowUnfreePredicate = pkg: import ./unfree.nix lib (getName pkg);
}
