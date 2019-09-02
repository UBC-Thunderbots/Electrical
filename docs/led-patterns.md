---
description: Description of the purposes of different LED colours and patterns.
---

# LED Patterns

## Red LEDs

There is one red LED on the board. This LED glows whenever the capacitors are charged to more than 35 volts. Consider the robot potentially dangerous when this LED is on.

## Yellow LEDs

The yellow LEDs are multipurpose LEDs attached to the FPGA. They are labelled `T0`, `T1`, and `T2`. In default configuration, `T0` glows when the break beam is interrupted and `T1` glows when auto-kick or auto-chip is armed. The modes can be changed \(temporarily\) in MRFTest to show things like optical encoder or Hall sensor signals.

These LEDs display a lamp test \(all three LEDs on\) for a short period of time after the FPGA bitstream loads.

## Green LEDs

The green `Power` LED is attached directly to the 3.3-volt supply and glows whenever the robot is on.

The `Link` and `OK` LEDs are attached to the microcontroller and indicate various things as follows:

#### Both off, only powered while holding the power switch in the Start position

* The microcontroller is not operating. It may not have code installed.

#### Both off, power maintained with the power switch in the On position

* New code is being copied from the SD card to the microcontroller. 

{% hint style="warning" %}
When flashing firmware, do not power down the robot!
{% endhint %}

#### OK on solid, Link off

* System is operating normally.

#### OK flashing slowly \(once per second\), Link off

* Safe mode: the microcontroller is working but the FPGA could not be initialized. This means that there may be no SD card inserted, no bitsteam or a corrupt bitstream on the SD card, or a communication problem between the microcontroller and either the SD card or the FPGA. Check the serial output for more details.

#### OK flashing quickly \(5× per second\), Link off

* DFU mode: the microcontroller has switched into firmware upgrade mode and is awaiting instructions or receiving data from DFU host software.

#### Both flashing isophase \(50% duty cycle\), once per second

* Crash: a core dump has been recorded.

#### OK flashing isophase \(50% duty cycle\), once per second, Link off

* Crash: an error occurred which prevented the core dump from being written.

