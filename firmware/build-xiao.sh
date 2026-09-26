#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${SCRIPT_DIR}/debugprobe/build"

# If PICO_SDK_PATH is not set in the environment, default to submodule
if [ -z "${PICO_SDK_PATH:-}" ]; then
  if [ -d "${SCRIPT_DIR}/pico-sdk" ]; then
    export PICO_SDK_PATH="${SCRIPT_DIR}/pico-sdk"
  fi
fi

# Ensure tinyusb submodule inside pico-sdk is present if using submodule
if [ -n "${PICO_SDK_PATH:-}" ] && [ -d "${PICO_SDK_PATH}/lib/tinyusb" ]; then
  if [ ! -f "${PICO_SDK_PATH}/lib/tinyusb/CMakeLists.txt" ]; then
    echo "Initializing tinyusb submodule in ${PICO_SDK_PATH}..."
    git -C "${PICO_SDK_PATH}" submodule update --init lib/tinyusb
  fi
fi

echo "=========================================================="
echo " Building SlickBug debugprobe for Seeed Studio XIAO RP2040"
echo "=========================================================="
echo " PICO_SDK_PATH : ${PICO_SDK_PATH:-Not set (using CMake FetchContent)}"
echo " Build Dir     : ${BUILD_DIR}"
echo ""

mkdir -p "${BUILD_DIR}"

cmake -B "${BUILD_DIR}" \
  -S "${SCRIPT_DIR}/debugprobe" \
  -DPICO_BOARD=seeed_xiao_rp2040 \
  -DDEBUG_ON_XIAO=ON \
  "$@"

cmake --build "${BUILD_DIR}" -j"$(nproc)"

UF2_BIN="${BUILD_DIR}/debugprobe_on_xiao_rp2040.uf2"
ELF_BIN="${BUILD_DIR}/debugprobe_on_xiao_rp2040.elf"

if [ -f "${UF2_BIN}" ]; then
  echo ""
  echo "=========================================================="
  echo " Build Succeeded!"
  echo "=========================================================="
  echo " UF2 Binary : ${UF2_BIN}"
  echo " ELF Binary : ${ELF_BIN}"
  echo ""
  echo " Flashing options:"
  echo " 1) Drag and drop ${UF2_BIN} onto the RPI-RP2 drive in BOOTSEL mode"
  echo " 2) Run: picotool load -f ${UF2_BIN}"
  echo "=========================================================="
fi
