{lib}: {
  root,
  exclude ? [],
}:
with builtins;
with lib;
# http://chriswarbo.net/projects/nixos/useful_hacks.html
  let
    basename = removeSuffix ".nix";

    isMatch = name: type:
      (hasSuffix ".nix" name || type == "directory")
      && ! elem name (map basename exclude);

    entry = name: _: {
      name = basename name;
      value = import (root + "/${name}");
    };
  in
    mapAttrs' entry (filterAttrs isMatch (readDir root))
