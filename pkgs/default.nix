{
  final,
  prev,
  flakes,
}:
with prev.lib; let
  inherit (final) callPackage fetchpatch;
in {
  homepage = flakes.homepage.packages.${final.system}.default;

  lib = callPackage ./lib {};

  st = prev.st.override {
    conf = import ./st.nix {};

    patches = [
      (fetchpatch {
        url = "https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff";
        sha256 = "cbb37675e9b4986836c19aadacc616a006df81c9bf394e9e3573e164fa1867cf";
      })
    ];
  };

  override =
    {
    }
    // (
      let
        makePyOverrides = version: let
          name = "python3${toString version}";
        in {
          inherit name;

          value = prev.${name}.override {
            packageOverrides = nextPy: prevPy: {
            };
          };
        };

        pyVersionRange' = start: end: let
          next = end + 1;
        in
          if prev ? "python3${toString next}"
          then pyVersionRange' start next
          else range start end;

        pyVersionRange = start: pyVersionRange' start start;
      in
        listToAttrs (map makePyOverrides (pyVersionRange 9))
    );
}
