{
  description = "SlickBug: Seeed Studio XIAO RP2040 CMSIS-DAP SWD Debug Probe & KiCad Hardware";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          name = "slick-bug-devshell";

          packages = with pkgs; [
            # Build systems & tooling
            cmake
            ninja
            gnumake
            pkg-config

            # ARM Bare-metal cross compiler (RP2040 Cortex-M0+)
            gcc-arm-embedded

            # Python 3 (required by Pico SDK code generation / PIO asm)
            python3

            # RP2040 flashing & inspection utility
            picotool

            # Debugging tools
            openocd
            probe-rs
            gdb
            clang-tools
            git
          ];

          shellHook = ''
            # Use local submodule pico-sdk if present and not overridden
            if [ -z "$PICO_SDK_PATH" ]; then
              if [ -d "$PWD/firmware/pico-sdk" ]; then
                export PICO_SDK_PATH="$PWD/firmware/pico-sdk"
              fi
            fi

            export PICO_TOOLCHAIN_PATH="${pkgs.gcc-arm-embedded}/bin"

            echo "=========================================================="
            echo " SlickBug XIAO RP2040 SWD Debug Probe Environment"
            echo "=========================================================="
            echo " ARM Toolchain : $(arm-none-eabi-gcc --version | head -n 1)"
            echo " CMake         : $(cmake --version | head -n 1)"
            echo " PICO_SDK_PATH : ''${PICO_SDK_PATH:-Not set (will auto-fetch)}"
            echo ""
            echo " Commands:"
            echo "   Build Xiao firmware : ./firmware/build-xiao.sh"
            echo "   Flash Xiao via UF2  : picotool load -f <build_dir>/debugprobe_on_xiao_rp2040.uf2"
            echo "   List probes         : probe-rs list"
            echo "   Test with OpenOCD   : openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg"
            echo "=========================================================="
          '';
        };
      });
    };
}
