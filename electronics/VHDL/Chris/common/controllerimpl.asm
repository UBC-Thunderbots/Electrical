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

.CODE
ORG 0
; Read inputs.
IN Setpoint Setpoint1
IN Encoder Encoder1
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADDS Error Setpoint
; Update integrator.
ADDS Integral1 Error
; Compute (Error:P) = Error * 1.
MOV P 1
MUL Error P
; Compute (Error:I) = Integral1 * 1.
MOV I 1
MOV Error Integral1
MUL Error I
; Compute Plant = (P + I) / 2.
MOV Plant P
ADDS Plant I
SEX P Plant
SHR32_1 P Plant
; Clamp to +/-1023 just in case.
CLAMP Plant 1023
; Write output.
OUT Plant1 Plant

; Read inputs.
IN Setpoint Setpoint2
IN Encoder Encoder2
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADDS Error Setpoint
; Update integrator.
ADDS Integral2 Error
; Compute (Error:P) = Error * 1.
MOV P 1
MUL Error P
; Compute (Error:I) = Integral2 * 1.
MOV I 1
MOV Error Integral2
MUL Error I
; Compute Plant = (P + I) / 2.
MOV Plant P
ADDS Plant I
SEX P Plant
SHR32_1 P Plant
; Clamp to +/-1023 just in case.
CLAMP Plant 1023
; Write output.
OUT Plant2 Plant

; Read inputs.
IN Setpoint Setpoint3
IN Encoder Encoder3
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADDS Error Setpoint
; Update integrator.
ADDS Integral3 Error
; Compute (Error:P) = Error * 1.
MOV P 1
MUL Error P
; Compute (Error:I) = Integral3 * 1.
MOV I 1
MOV Error Integral3
MUL Error I
; Compute Plant = (P + I) / 2.
MOV Plant P
ADDS Plant I
SEX P Plant
SHR32_1 P Plant
; Clamp to +/-1023 just in case.
CLAMP Plant 1023
; Write output.
OUT Plant3 Plant

; Read inputs.
IN Setpoint Setpoint4
IN Encoder Encoder4
; Compute Error = Setpoint - Encoder.
NEG Error Encoder
ADDS Error Setpoint
; Update integrator.
ADDS Integral4 Error
; Compute (Error:P) = Error * 1.
MOV P 1
MUL Error P
; Compute (Error:I) = Integral4 * 1.
MOV I 1
MOV Error Integral4
MUL Error I
; Compute Plant = (P + I) / 2.
MOV Plant P
ADDS Plant I
SEX P Plant
SHR32_1 P Plant
; Clamp to +/-1023 just in case.
CLAMP Plant 1023
; Write output.
OUT Plant4 Plant

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
