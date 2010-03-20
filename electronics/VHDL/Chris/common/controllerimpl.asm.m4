.META
Entity = ControllerImpl

.VARS
; Z^-1 and Z^-2 for each wheel, each over the interval ±4095, with 13 bits of
; integer component and 3 bits of fractional component.
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
; Output of right-hand adder.
PlantH = 0
PlantL = 0

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
; For now, we store Z0 as 16 bits integer and 16 bits fractional.
MOV Z0H Error
MOV Z0L 0
; Compute -A1 Z1.
; A1 = -1.7776 => -A1 = 1.7776.
; Z1 in ±4095, formatted in 13.3.
; Encode -A1 in 3.13, raw value 14562, error 0.0007%.
; -A1 Z1 is in format 16.16.
MOV TempH W'$1`Z1
MOV TempL 14562
MUL TempH TempL
ADD Z0L TempL
ADDC Z0H TempH
; Compute -A2 Z2.
; A2 = 0.7776 => -A2 = -0.7776.
; Z2 in ±4095, formatted in 13.3.
; Encode -A2 in 3.13, raw value -6370, error 0.002%.
; -A2 Z2 is in format 16.16.
MOV TempH W'$1`Z2
MOV TempL -6370
MUL TempH TempL
ADD Z0L TempL
ADDC Z0H TempH

; Z0 is in 16.16 format. First, clamp it to ±4095.
CLAMP Z0H 4095
; Now convert it to 13.3 by shifting right 13 bits.
SHR32_4 Z0H Z0L
SHR32_4 Z0H Z0L
SHR32_4 Z0H Z0L
SHR32_1 Z0H Z0L

; Plant value is the sum of B0 Z0, B1 Z1, and B2 Z2.
; Compute B0 Z0.
; B0 = 1.0457.
; Z0 in ±4095, formatted in 13.3.
; Encode B0 in 3.13, raw value 8566, error 0.004%.
; B0 Z0 is in format 16.16.
MOV PlantH Z0L
MOV PlantL 8566
MUL PlantH PlantL
; Compute B1 Z1.
; B1 = -0.0619.
; Z1 in ±4095, formatted in 13.3.
; Encode B1 in 3.13, raw value -507, error 0.02%.
; B1 Z1 is in format 16.16.
MOV TempH W'$1`Z1
MOV TempL -507
MUL TempH TempL
ADD PlantL TempL
ADDC PlantH TempH
; Compute B2 Z2.
; B2 = -0.9504.
; Z2 in ±4095, formatted in 13.3.
; Encode B2 in 3.13, raw value -7786, error 0.004%.
; B2 Z2 is in format 16.16.
MOV TempH W'$1`Z2
MOV TempL -7786
MUL TempH TempL
ADD PlantL TempL
ADDC PlantH TempH

; Plant is in 16.16 format. First, clamp it to ±1023.
CLAMP PlantH 1023
; Now output it.
OUT Plant'$1` PlantH

; Perform the unit delays.
MOV W'$1`Z2 W'$1`Z1
MOV W'$1`Z1 Z0L
'')

.CODE
ORG 0

controller(1)

controller(2)

controller(3)

controller(4)

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
