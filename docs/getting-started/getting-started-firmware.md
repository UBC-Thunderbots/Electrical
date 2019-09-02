---
description: >-
  Setup instructions on how to build and flash both microcontroller firmware and
  the FPGA bitstream as well as any related tools.
---

# Getting Started - Firmware

## General Use

### **Download Code from Repository**

Before doing anything, you need to check out the Thunderbots repository which contains our files. On Linux, follow these instructions:

1. Install git, by running the command

   `sudo apt-get install git` as root.

2. Go to the folder that you want to install the code in run the command `git clone https://github.com/UBC-Thunderbots/Software.git` . You will be prompted for, in sequential order,
   1. the password to your computer,
   2. your username to the thunderbots repo
   3. your password to your thunderbots username
3. Run the command cd thunderbots/trunk
4. Run the command `git pull` \(This will make sure you are at the latest revision\)

On Windows, follow these instructions:

1. To download git on your windows laptop, go to [https://git-scm.com/downloads](https://git-scm.com/downloads) and download the latest version of git.
2. Follow the download instructions, this download should come with a git bash.
3. Go to your desktop and right click. There should be an option that says Git Bash Here.
4. You will be in the Desktop directory, use the command `cd../`
5. Navigate to the folder you want to place the repository in using `cd "foldername"/` to go into that folder and `cd ../` to go back one folder.
6. If you need to make a folder use the command `mkdir "foldername"`
7. Once in the correct folder run the command `git clone git@gitlab.com:thunderbotsfc/Electrical.git`. You will be prompted for, in sequential order,
   1. the password to your computer,
   2. your username to the thunderbots repo
   3. your password to your thunderbots username

### **Thunderbot UDev Rules**

You need to have filesystem permission to access USB devices. These steps give you those permissions.

1. Run the command `sudo groupadd thunderbots`. This creates a system group named “thunderbots”. 
2. Run the command `sudo gpasswd -a myuser thunderbots` . This places your user in the group. 
3. Log out and back in so the new membership is activated. 
4. Copy the file 99-thunderbots.rules from `docs/EnvironmentSetup` into `/etc/udev/rules.d` with the command `sudo cp trunk/docs/EnvironmentSetup/99-thunderbots.rules /etc/udev/rules.d`This is secure and will grant access to the dongle and robots but nothing else.

### **Building the Testing Software** 

TODO: Add stuff about the running script file and cmake

### **Running the Testing Software**

Once the testing software is compiled, run it with `bin/mrftest`.

### Firmware Development

Firmware development can only be done in Linux. 

* Install an [ARM Hardfloat Toolchain for STM32F4](ARM-Hardfloat-Toolchain-for-STM32F4) to compile the firmware.
* Get a copy of ​`DFU-Util` in order to burn code onto the boards

{% hint style="info" %}
Most Linux distributions include `DFU-Util` in their repositories, but make sure you have at least version 0.7 

If the version in your repository is older than 0.7, install it from the website instead.
{% endhint %}

### **Compiling Firmware**

To compile firmware for the robot or dongle, run `make`  in the appropriate directory \(either `firmware/main` or `firmware/dongle`, respectively\).

### **Installing Firmware—Robot**

The canonical storage location for robot firmware is in the on-board Flash memory of the microcontroller. To install new firmware on a robot, you have a number of options. You will probably want one of the first few options most of the time.

### **Install over USB cable to a working robot** 

To do this, run `make dfu` in the `firmware/main` directory. This switches the robot into DFU mode, writes a temporary copy of the new firmware image to the SD card, and then launches a stub function which copies the firmware back from the SD card to the microcontroller.

### **Install onto a working robot’s SD card using an SD card reader**

1. Compile the `sdutil` binary in the `Software` directory with `make bin/sdutil` if necessary
2. Then, in the `firmware/main` directory, run `../../software/bin/sdutil /dev/mmcblk0 install main.bin firmware ephemeral`

{% hint style="info" %}
You will need to replace `/dev/mmcblk0` with the device node of your SD card reader if necessary. This might be `/dev/sdX` for some letter `X`, if you are using a USB mass storage card reader.

This copies a firmware image onto the SD card. 
{% endhint %}

{% hint style="warning" %}
Inserting the SD card back into the robot and starting up the robot will cause the robot to install the new firmware and, because the image is marked ephemeral, delete the image from the SD card afterwards.
{% endhint %}

### **Install onto many working robots via a gold master SD card**

To do this, follow the instructions for the previous option, but use a separate SD card and replace the word `ephemeral` with `normal`. This signals the robot to leave the image on the card after installation is complete. You can now take the SD card to multiple robots and install the new firmware on all of them.

### **Install over SWD cable via GDB**

While doing in-circuit debugging via OpenOCD, the GDB commands `file main.elf` followed by `load` will load new firmware onto the robot. You need to hold the power switch in the start position while loading to prevent the robot from powering down.

### **Install over USB cable using the ROM bootloader to a working, bricked, or blank robot**

1. Put the robot into `bootload` mode by flipping down the switch marked `BL` on the piano keys.
2. Hold the power switch in the start position.
3. Run `make dfuse` and wait for the transfer to complete. 
4. Once finished, flip the configuration bootload key back up position.

### **Installing Firmware—Dongle**

To install new firmware on a dongle, run `make dfu` in `firmware/dongle`. If the dongle is blank or bricked, you will need to unplug the USB cable, then plug it back in while holding down the bootload button \(the button can be released once the board powers up\) before running `make dfu`. You can also use the `file dongle.elf` and `load` GDB commands if you are doing in-circuit debugging over the SWD connector with OpenOCD.

## FPGA Bitstream Development

FPGA bitstream development can only be done in Linux. You will need to install ​[http://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools.html](http://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools.html) Xilinx ISE WebPack \(not Vivado!\) to synthesize the VHDL sources into an FPGA bitstream \(get the Full Installer for Linux file\). You will also need a copy of [​DFU-Util](http://dfu-util.sourceforge.net/) in order to burn code onto the boards; most Linux distributions include DFU-Util in their repositories, but make sure you have at least version 0.7 \(if the version in your repository is older than 0.7, install from the website instead\). Finally, you will want ​the [GHDL VHDL simulator](http://ghdl.free.fr/) and ​the [GTKWave wave viewer](http://gtkwave.sourceforge.net/), both of which are probably available in your Linux distribution’s repositories.

### **Running Test Benches**

To run the test benches using GHDL, run `make test`.

### **Synthesizing the Bitstream**

To synthesize the FPGA bitstream data for the robot, run `make synth`.

If you're getting errors, it's most likely that your `XILINX_SETTINGS` environment variable is pointing to the wrong place. Find where your Xilinx settings{32,64}.sh file \(mine is at `/opt/Xilinx/14.7/ISE_DS/settings64.sh`\) and change the value of the `XILINX_SETTINGS` environment variable in the Makefile. If you're still getting errors run `make help` to get a helpful message.

### **Installing the Bitstream**

The canonical storage location for the FPGA bitstream is on the robot’s SD card. To install a new bitstream on a robot, you have a few options. In all cases, you must already have working firmware installed before the bitstream will be loaded and boot the FPGA.

### **Install over USB cable**

Run `make dfu` in the `vhdl` directory. This switches the robot into DFU mode and writes the new bitstream to the SD card.

### **Install using an SD card reader**

1. Compile the `sdutil` binary in the `Software` directory with `make bin/sdutil` if necessary
2. Go to the `vhdl` directory and run `../../Software-Firmware/software/bin/sdutil /dev/mmcblk0 install thunderbots.bin fpga normal`

{% hint style="info" %}
You will have to replace `/dev/mmcblk0` in step 2 with the device node of your SD card reader if necessary. This might be `/dev/sdX` for some letter `X`, if you are using a USB mass storage card reader.
{% endhint %}

## SD Card Logging

To review logged data from dead reckoning and movement primitives, run the `sdutil` program in the `Software` directory. 

1. Compile the `sdutil` binary in the `Software` directory by running `make bin/sdutil`. 
2. Once it is built, use `./bin/sdutil /dev/mmcblk0 info` in order to verify the epoch number that you wish to load. 
3. To load the data to a `.tsv` file, run `./bin/sdutil /dev/mmcblk0 tsv <epoch> <file_name>`. 

{% hint style="warning" %}
The file will have many columns, so it is highly recommended to open the `.tsv` file with spreadsheet software.
{% endhint %}

## Firmware Debugging

1. Plug in the robot to your computer.
2. Run the following from Linux command line: `sudo cat /dev/ttyACM*`
3. Turn on the robot.
4. All `fputs`statements in the firmware will now print to your command line window.

