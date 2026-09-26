{
  description = "C/C++ CMake development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            gnumake
            ninja
            pkg-config

            # Debugging & tooling (optional, remove if not needed)
            gdb
            clang-tools # clang-format, clang-tidy
          ];

          # pkgs.mkShell automatically pulls in `stdenv.cc` (GCC, ld, glibc-dev, standard headers)
          # and sets up $CC, $CXX, and library search paths for CMake.
        };
      });
    };
}
