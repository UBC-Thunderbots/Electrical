# Getting Started - CAD Software

Setup instructions on how install CAD software for schematic capture and PCB layout.

---
In the past, the team has used KiCAD. However, in the fall of 2017, we began to move all the schematics to Altium. 

## Altium Setup
Altium is only compatible with Windows. We currently use **version 18.0**. For more information on the system requirements for this version of Altium, go [here](https://www.altium.com/documentation/altium-designer/altium-designer-system-requirements?version=18.0).

### Part 1 - Installation

1. Create an [Altium Live account](https://live.altium.com/#Join). Once the request is sent, it may take a few days for approval. Note: If you do not see any entry fields for your information on the linked page, try a different browser.
2. Once approved, go to the [Altium downloads page](https://www.altium.com/products/downloads).
3. Install Altium Designer using either the online or offline installer.


### Part 2 - License Setup

1. If on campus, connect to either **UBCSecure** or **UBCPrivate**. No other wireless network will work. For remote use, you can VPN into the ECE license serve. Go [here ](getting-started-cad-software-wip.md#myvpn-setup)to setup myVPN.
2. Open Altium and select `Setup private license server`.

![](../../.gitbook/assets/altium1.PNG)

3. Fill in the `Server name` and `Server port` with the information from the `README.html` file. The server will be `altium-lm.ece.ubc.ca` but the port is dependent on the current license. Once filled out, click `OK`.

![](../../.gitbook/assets/altium2.PNG)

4.    Scroll down under `Available Licenses` until `Private Server`.

![](../../.gitbook/assets/altium3.PNG)

5.   Select the license shown in the above photo, and then click `Use`.

6.    If the license setup is successful, it should say `Used by me` under `Used`.

![](../../.gitbook/assets/altium4.PNG)

If the connection is not successful, try the following:

If you are on campus, ensure that you are connected to **UBCSecure** or **UBCPrivate**. 

If you are using the license remotely, ensure that you are connected to myVPN. 

### myVPN Setup

Go [here](https://it.ubc.ca/services/email-voice-internet/myvpn/setup-documents) and follow the instructions. Be sure to go over the information on system compatibility.

## KiCAD Setup

KiCAD is compatible with several operating systems!

To install KiCAD, go [here](http://kicad-pcb.org/download/).
