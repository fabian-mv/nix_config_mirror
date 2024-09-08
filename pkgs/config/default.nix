lib:
with lib; {
  android_sdk.accept_license = true; #TODO: what the fuck is this
  allowUnfreePredicate = pkg: import ./unfree.nix lib (getName pkg);
}
