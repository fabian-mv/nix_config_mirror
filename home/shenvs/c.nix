{pkgs, ...}: {
  static = true;

  packages = with pkgs; [
    binutils
    cmake
    curl
    gdb
    gnumake
    rustup
    valgrind
  ];
}
