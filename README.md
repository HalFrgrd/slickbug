
# SlickBug

A small SWD programmer using the Seeed Studio XIAO RP2040.
I wanted a compact debugger with a tiny target footprint.

It uses 4 P50 test pins which are mounted on the back of the PCB.
The test pins sit in R50 receptacles which are held in place with 2 PCB "combs".
The GND pin extends 1.5mm further so that GND connects first.

![SlickBug assembled](assets/slickbug_v1_bottom.jpg)
![SlickBug assembled](assets/slickbug_v1_top.jpg)
![SlickBug in action](assets/slickbug_v1_in_action.jpg)

### Pin order
1. GND
2. SWCLK
3. SWDIO
4. VCC (3V3)


### Assembly



### Building the firmware
1. `nix develop`
2. `./firmware/build-xiao.sh`
3. Put XIAO RP2040 into BOOTSEL mode (hold BOOT, tap RESET, release BOOT)
