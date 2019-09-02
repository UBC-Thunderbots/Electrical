# Usb implementation



The dongle appears as a standard full-speed \(12 Mb/s\) device with vendor ID 0x0483 \(shared with STMicro\) and product ID 0x497C. The dongle exposes an interface having bInterfaceClass set to 0xFF \(vendor class\) and bInterfaceSubClass set to MRF\_DONGLE\_SUBCLASS. This interface declares three alternate settings for the three operating modes of the radio: radio off, normal mode, and promiscuous mode; the alternate settings can be identified by checking their bInterfaceProtocol values.

### Control Transfers

The dongle accepts certain vendor-class control transfers in addition to the standard transfers defined by the USB specification. These must be addressed to the radio protocol interface.

Many of these control transfers set parameters for the radio; these are issued in the Radio Off alternate setting and applied when the radio is enabled.

**Get Channel**

| Accepted in alternate setting | All |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=IN, type=vendor, recipient=interface\) |
| bRequest | 0x00 |
| wValue | 0x0000 |
| wLength | 1 |

Returns a single byte containing the 802.15.4 channel number on which the station communicates, from 0x0B to 0x1A inclusive.

**Set Channel**

| Accepted in alternate settings | Radio Off |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x01 |
| wValue | 802.15.4 channel number, from 0x0B to 0x1A inclusive |
| wLength | 0 |

Sets the current channel number. The channel number defaults to 0x0B at power-up.

**Get Symbol Rate** 

| Accepted in alternate settings | All |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=IN, type=vendor, recipient=interface\) |
| bRequest | 0x02 |
| wValue | 0x0000 |
| wLength | 1 |

Returns a single byte with one of the following values:

| Value | Meaning |
| :--- | :--- |
| 0x00 | 50 kb/s 802.15.4-compliant symbol rate |
| 0x01 | 625 kb/s Microchip-proprietary symbol rate |
| 0x02–0xFF | Reserved |

**Set Symbol Rate**

| Accepted in alternate settings | Radio Off |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x03 |
| wValue | 0x0000: 250 kb/s 802.15.4-compliant symbol rate  0x0001: 625 kb/s Microchip-proprietary symbol rate   0x0002–0xFFFF: Reserved |
| wLength | 0 |

Sets the symbol rate for radio communication. The symbol rate defaults to 250 kb/s at power-up.

**Get PAN ID**

| Accepted in alternate settings | All |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=IN, type=vendor, recipient=interface\) |
| bRequest | 0x04 |
| wValue | 0x0000 |
| wLength | 2 |

Returns two bytes containing the 802.15.4 PAN ID on which the station communicates, or 0xFFFF if not configured yet.

**Set PAN ID**

| Accepted in alternate settings | Radio Off |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x05 |
| wValue | 802.15.4 PAN ID, from 0x0000 to 0xFFFE inclusive |
| wLength | 0 |

Sets the PAN ID for radio communication. The PAN ID defaults to unset at power-up and must be set to a value other than 0xFFFF before entering normal mode.

**Get MAC Address**

| Accepted in alternate settings | All |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=IN, type=vendor, recipient=interface\) |
| bRequest | 0x06 |
| wValue | 0x0000 |
| wLength | 8 |

Returns eight bytes containing the station’s MAC address.

**Get Access Control Bitmask**

| Accepted in alternate settings | Normal |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=IN, type=vendor, recipient=interface\) |
| bRequest | 0x07 |
| wValue | 0x0000 |
| wLength | ceil\(`MAX_ROBOTS`÷8\) |

Returns the station’s access control bitmask, indicating which robots are allowed to associate. Bit b of byte n is for robot 8n+b.

**Set Access Control Bitmask**

| Accepted in alternate settings | Normal |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x08 |
| wValue | 0x0000 |
| wLength | ceil\(`MAX_ROBOTS`÷8\) |

Sets the station’s access control bitmask.

**Get Promiscuous Flags**

| Accepted in alternate settings | Promiscuous |
| :--- | :--- |
| bmRequestType | 0xC1 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x09 |
| wValue | 0x0000 |
| wLength | 2 |

Returns two bytes containing the promiscuous flags.

**Set Promiscuous Flags**

| Accepted in alternate settings | Promiscuous |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x0A |
| wValue | See below |
| wLength | 0 |

Sets new promiscuous flags. The promiscuous flags are only used in promiscuous mode and are cleared to 0x0000 on entering that mode, preventing any frames from being accepted. When a packet is observed by the dongle, the promiscuous flags control whether the packet is reported to the application and whether an acknowledgement is returned to the sender if requested.

`wValue` is taken to be a bit field with the following elements:

| Bit index | Values |  |
| :--- | :--- | :--- |
| 0 | 0 = Do not generate acknowledgement frames; RF switch permanently locked in receive mode and power amplifier disabled  **OR** 1 = Generate acknowledgement frames to received data that requests them; RF switch enabled as usual and power amplifier enabled |  |
| 1 | 0 = Receive only frames that match the station’s PAN ID **OR** 1 = Ignore PAN ID when matching frames |  |
| 2 | 0 = Receive only frames directed at station’s MAC address and broadcast packets **OR** 1 = Ignore MAC addresses when matching frames |  |
| 3 |  | 0 = Receive only frames with correct frame check sequence **OR** 1 = Ignore frame check sequence when matching frames |
| 4 | 0 = Ignore data frames **OR** 1 = Accept data frames |  |
| 5 | 0 = Ignore command frames **OR** 1 = Accept command frames |  |
| 6 | 0 = Ignore beacon frames **OR** 1 = Accept beacon frames |  |
| 7 | 0 = Ignore frames with invalid frame type **OR** 1 = Accept frames with invalid frame type |  |
| 8–15 | Reserved, must be 0 |  |

Not all combinations of filter parameters can be installed directly in the radio hardware. When acknowledgements are enabled, they are generated by the radio hardware without the involvement of the firmware; this means that only filters that can be represented precisely in the radio hardware can be installed when using acknowledgements. Any attempt to install a filter that cannot be fully reduced to the hardware’s capabilities when acknowledgements are enabled will result in a protocol stall for the transfer and no change to the dongle’s configuration. The specific limitations of the radio are as follows:

* Either exactly one or else all three of bits 4 through 6 must be set to 1.
* Either none or all of bits 1, 2, and 7 must be set to 1.
* If bit 7 is set to 1, bits 4 through 6 must also all be set to 1.

When acknowledgements are disabled, these limitations do not apply. Components of the filter configuration that are precisely representable in the radio hardware are installed there; components that are not representable are checked in firmware.

**Beep**

| Accepted in alternate settings | All |
| :--- | :--- |
| bmRequestType | 0x41 \(direction=OUT, type=vendor, recipient=interface\) |
| bRequest | 0x0B |
| wValue | Length of tone in milliseconds |
| wLength | 0 |

Activates the dongle’s on-board buzzer for a specified length of time. If the buzzer is already active when this transfer is received, the current tone will be lengthened \(but not shortened\) to last `wValue` milliseconds into the future.

### Radio Off

In this alternate setting, the radio is disabled and will neither transmit nor receive frames. Certain control requests become available to set configuration parameters. This alternate setting contains no endpoints.

### Normal Mode

In this alternate setting, the radio is awake and acts as a robot control base station. This alternate setting exposes the following endpoints:

**Interrupt IN endpoint 1 and bulk IN endpoint 2: Combined Data and Status Notifications**

These endpoints carry both data packets received from the robots and also notifications of various events. An application must poll both endpoints; the dongle delivers transfers over both endpoints, choosing an endpoint based on the priority of the message being delivered. In all cases, one USB transfer contains exactly one logical message, and the application shall expect a maximum transfer length of 128 bytes. A message comprises a two-byte header \(the first byte being the index of the robot to which the message relates and the second being the type of message\) followed by a variable-length message payload. The valid message types are such events as run switch state changed, robot associated or disassociated, message delivery reports for LL-Out messages, and received inbound messages; the exact list is in constants.h along with the format of each message payload.

**Interrupt OUT endpoint 1: Data Transmission**

This endpoint carries messages to be transmitted to robots. The dongle expects a maximum transfer length of 128 bytes. The first byte of a transfer must be either a robot number, if delivering an LL-Out message, or the value 0xFF, if delivering a complete set of HF-Out messages. The remainder of the transfer depends on the value of this first byte.

A transfer of length zero is ignored.

_LL-Out Message_

The second byte of an LL-Out message transfer is the epoch number, which must match the value provided by the most recent association notification for the robot \(if this does not match, in order to maintain the epoch binding property, the message is rejected and the MDR, if requested, indicates the reason\). The third byte is the message identifier; if this is 0xFF, no message delivery report will be generated, but if it is any other value, the value is ignored by the dongle but is included in the message delivery report and can be used to match MDRs to messages. The remaining bytes in the transfer are the message payload.

Attempting to send a message to an unassociated robot results in an MDR \(if requested\) indicating the reason for failure. Attempting to send a message to a robot index of MAX\_ROBOTS or higher results in an endpoint halt. Sending a transfer that is short enough that either the epoch number or the message ID is missing results in an endpoint halt; however, sending an empty payload is legal and results in a zero-length LL-Out message being sent.

_HF-Out Message Set_

An HF-Out message set delivers new HF-Out messages to all robots simultaneously. Following the leading byte of the transfer, the rest of the transfer comprises a sequence of HF-Out message structures. Each message structure comprises one byte containing the index of the robot to receive this message, followed by one byte containing the robot’s association epoch number, followed by the message payload; the latter is always exactly HF\_OUT\_LEN bytes.

When the transfer completes, the next HF-Out broadcast will contain all the new messages; any robots not included in the transfer will receive an HF-Out message containing all zeroes.

Including an HF-Out message for an unassociated robot results in the message being silently discarded. Including an HF-Out message for an associated robot with the wrong epoch number results in the message being silently dropped and the robot receiving all zeroes. Including an HF-Out message for a robot index of MAX\_ROBOTS or higher results in an endpoint halt. Sending a transfer whose length does not allow it to contain exactly an integral number of HF-Out message structures results in an endpoint halt; however, sending an otherwise-well-formed transfer with no HF-Out message structures is legal and results in all robots receiving all zeroes.

### Promiscuous Mode

In this alternate setting, the radio is awake and receives, but does not normally transmit, frames \(it will transmit acknowledgement frames if instructed to do so in the promiscuous flags; it will not transmit any other type of frame\). The application can initiate packet reception by sending a Set Promiscuous Flags control transfer to enable frame types of interest. This alternate setting contains one endpoint.

**Bulk IN endpoint 1: Received Frames**

This endpoint declares a maximum packet size of 64 bytes. It delivers one whole transfer \(consisting of one or more transactions the last of which carries less than 64 bytes of payload\) for each frame received off the air which successfully matches the configured filters. The payload consists of the following bytes:

| Length | Contents |
| :--- | :--- |
| 1 | Flags \(see below\) |
| 1 | Channel |
| 6 | Timestamp, relative to start of promiscuous operation, in microseconds |
| 0–125 | Frame data \(including MAC header\) |
| 2 | Frame check sequence |
| 1 | Link quality indicator |
| 1 | Received signal strength indicator |

The flags are a bit field defined as follows

| Bit | Meaning |
| :--- | :--- |
| 0 | 0: Buffering OK **OR** 1: A frame prior to this one was dropped because internal buffers were filled faster than the host drained them via USB |
| 1–7 | Reserved, always 0 |

