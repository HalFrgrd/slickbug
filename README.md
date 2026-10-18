
# SlickBug

A small SWD programmer using the Seeed Studio XIAO RP2040.
I wanted a compact debugger with a tiny target footprint.

It uses four R50 test probe receptacles which are mounted on the back of the PCB and are held in place using two PCB "combs".
P50 test probes sit in the R50 receptacles.  The GND pin extends 1.5mm further so that GND connects first.

<p align="center">
  <img src="assets/slickbug_v1_bottom.jpg" alt="SlickBug assembled" width="32%" />
  <img src="assets/slickbug_v1_top.jpg" alt="SlickBug assembled" width="32%" />
  <img src="assets/slickbug_v1_in_action.jpg" alt="SlickBug in action" width="32%" />
</p>

## Target footprint

The target footprint is 4 pads with pitch 1.27mm.

The pin order:
1. GND
2. SWCLK
3. SWDIO
4. VCC (3V3)

The footprints are found in ...

### Ordering and assembly

Drag the [production files](hardware/production/slick_bug.zip) to JLCPCB's order page to get the PCBs. 1.6mm thick so that the combs work as intended.

You can get the [components](hardware/production/bom.csv) from LCSC and combine your order with JLCPCB. I bought the test probes and receptacles from AliExpress.

You will need to snap off the combs from the pcb to hold the R50 receptacles in place.

<p align="center">
  <img src="assets/slickbug_v1_pcb.jpg" alt="SlickBug pcb" width="45%" />
  <img src="assets/slickbug_v1_assembling.jpg" alt="SlickBug assembling" width="45%" />
</p>


### Building the firmware
1. `nix develop`
2. `./firmware/build-xiao.sh`
3. Put XIAO RP2040 into BOOTSEL mode (hold BOOT, tap RESET, release BOOT)
