.META
Entity = ControllerImpl

.VARS
; Z^-1 and Z^-2 for each wheel, each over the interval ±32000, with 16 bits of
; integer component.
W1Z1 = 0
W1Z2 = 0
W2Z1 = 0
W2Z2 = 0
W3Z1 = 0
W3Z2 = 0
W4Z1 = 0
W4Z2 = 0
; Setpoint, interval ±1023, with 5 unused bits and 11 bits of integer component.
Setpoint = 0
; Encoder, interval ±1023, with 5 unused bits and 11 bits of integer component.
Encoder = 0
; Encoder - Setpoint, interval ±2046, with 4 unused bits and 12 bits of integer
; component.
Error = 0
; Intermediate value.
TempL = 0
TempH = 0
; Output of left-hand adder.
Z0L = 0
Z0H = 0
; Outputs of right-hand adders.
Plant1H = 0
Plant1L = 0
Plant2H = 0
Plant2L = 0
Plant3H = 0
Plant3L = 0
Plant4H = 0
Plant4L = 0

.IPORTS
Setpoint1
Setpoint2
Setpoint3
Setpoint4
Encoder1
Encoder2
Encoder3
Encoder4

.OPORTS
Plant1 = 0
Plant2 = 0
Plant3 = 0
Plant4 = 0

dnl Macro "controller" implements a single wheel controller.
dnl Parameter is the index of the wheel to control.
dnl 
dnl We currently implement a Direct Form 2 controller as described at
dnl <http://en.wikipedia.org/wiki/File:Biquad_direct_form2.png>
dnl with the following parameters:
dnl
dnl A1=-1.7776
dnl A2=0.7776
dnl B0=1.0457
dnl B1=-0.0619
dnl B2=-0.9504
dnl
dnl Clamping is applied after each adder; the first adder clamps to within ±4095
dnl and the second to within ±1023.
define(`controller',``
; Read inputs.
IN Setpoint Setpoint'$1`
IN Encoder Encoder'$1`
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADD Error Setpoint

; Z0 is the sum of Error, -A1 Z1, and -A2 Z2. Initialize to Error.
; For now, we store Z0 in format 18.14.
MOV Z0H Error
MOV Z0L 0
SHR32_2 Z0H Z0L
; Compute -A1 Z1.
; A1 = -1.7776 => -A1 = 1.7776.
; Z1 in ±32000, formatted in 16.0.
; Encode -A1 in 2.14, raw value 29124, error 0.0007%.
; -A1 Z1 is in format 18.14.
MOV TempH W'$1`Z1
MOV TempL 29124
MUL TempH TempL
ADD Z0L TempL
ADDC Z0H TempH
; Compute -A2 Z2.
; A2 = 0.7776 => -A2 = -0.7776.
; Z2 in ±32000, formatted in 16.0.
; Encode -A2 in 2.14, raw value -12740, error 0.002%.
; -A2 Z2 is in format 18.14.
MOV TempH W'$1`Z2
MOV TempL -12740
MUL TempH TempL
ADD Z0L TempL
ADDC Z0H TempH

; Z0 is in 18.14 format. First, clamp it to ±32767.
; Do this by clamping its upper byte to ±8192.
CLAMP Z0H 8192
; Now convert it to 16.0 by shifting right 14 bits.
SHR32_4 Z0H Z0L
SHR32_4 Z0H Z0L
SHR32_4 Z0H Z0L
SHR32_2 Z0H Z0L
; Reclamp to ±32000.
CLAMP Z0L 32000

; Plant value is the sum of B0 Z0, B1 Z1, and B2 Z2.
; Compute B0 Z0.
; B0 = 1.0457.
; Z0 in ±32000, formatted in 16.0.
; Encode B0 in 2.14, raw value 17133, error 0.001%.
; B0 Z0 is in format 18.14.
MOV Plant'$1`H Z0L
MOV Plant'$1`L 17133
MUL Plant'$1`H Plant'$1`L
; Compute B1 Z1.
; B1 = -0.0619.
; Z1 in ±32000, formatted in 16.0.
; Encode B1 in 2.14, raw value -1014, error 0.02%.
; B1 Z1 is in format 18.14.
MOV TempH W'$1`Z1
MOV TempL -1014
MUL TempH TempL
ADD Plant'$1`L TempL
ADDC Plant'$1`H TempH
; Compute B2 Z2.
; B2 = -0.9504.
; Z2 in ±32000, formatted in 16.0.
; Encode B2 in 2.14, raw value -15571, error 0.002%.
; B2 Z2 is in format 18.14.
MOV TempH W'$1`Z2
MOV TempL -15571
MUL TempH TempL
ADD Plant'$1`L TempL
ADDC Plant'$1`H TempH

; Plant is in 18.14 format. First, clamp it to ±1024.
; Do this by clamping the upper byte to ±256.
CLAMP Plant'$1`H 256
; Now convert it to 16.0 by shifting right 14 bits.
SHR32_4 Plant'$1`H Plant'$1`L
SHR32_4 Plant'$1`H Plant'$1`L
SHR32_4 Plant'$1`H Plant'$1`L
SHR32_2 Plant'$1`H Plant'$1`L
; Reclamp to precisely ±1023.
CLAMP Plant'$1`L 1023
; Convert to sign-magnitude representation.
SMAG Plant'$1`L Plant'$1`L

; Perform the unit delays.
MOV W'$1`Z2 W'$1`Z1
MOV W'$1`Z1 Z0L
'')

.CODE
ORG 0

; Execute the controllers.
controller(1)
controller(2)
controller(3)
controller(4)

; Output the plant values.
OUT Plant1 Plant1L
OUT Plant2 Plant2L
OUT Plant3 Plant3L
OUT Plant4 Plant4L

; Done!
HALT



ORG 512
; Clear unit-delayed values.
MOV W1Z1 0
MOV W1Z2 0
MOV W2Z1 0
MOV W2Z2 0
MOV W3Z1 0
MOV W3Z2 0
MOV W4Z1 0
MOV W4Z2 0
; Done!
HALT
