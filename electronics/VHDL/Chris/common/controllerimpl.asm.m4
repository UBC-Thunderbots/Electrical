.META
Entity = ControllerImpl

.VARS
Integral1 = 0
Integral2 = 0
Integral3 = 0
Integral4 = 0
Setpoint = 0
Encoder = 0
Error = 0
P = 0
I = 0
Plant = 0

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
define(`controller',``; Read inputs.
IN Setpoint Setpoint'$1`
IN Encoder Encoder'$1`
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADD Error Setpoint
; Update integrator.
ADD Integral'$1` Error
CLAMP Integral'$1` 4095
; Compute (Error:P) = Error * 1.
MOV P 1
MUL Error P
; Compute (Error:I) = Integral'$1` * 1.
MOV I 1
MOV Error Integral'$1`
MUL Error I
; Compute Plant = (P + I) / 2.
MOV Plant P
ADD Plant I
SEX P Plant
SHR32_1 P Plant
; Clamp to PWM range.
CLAMP Plant 1023
; Write output.
OUT Plant'$1` Plant'')

.CODE
ORG 0

controller(1)

controller(2)

controller(3)

controller(4)

; Done!
HALT



ORG 512
; Clear integrators.
MOV Integral1 0
MOV Integral2 0
MOV Integral3 0
MOV Integral4 0
; Done!
HALT
