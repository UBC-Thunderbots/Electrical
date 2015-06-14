%%Wheel angles are
Theta = [55 135 225 305];
Radians = Theta * pi / 180;

%Center of mass displacement in normalized radial coordinates
D = [-0.0556; 0]; %(Dx Dy)/Robot_Radius

WheelPosition = [cos(Radians); sin(Radians)];
DeltaPosition = WheelPosition - D*ones(1,4);
ForceVector = [-sin(Radians); cos(Radians)];
CrossMat = [0 1; -1 0];
Torque = diag(DeltaPosition'*CrossMat*ForceVector);


%Force mat couples wheel force to robot force
ForceCouplingMat = [ForceVector; Torque'];
InvForceCouplingMat = pinv(ForceCouplingMat); %unitless

%Vel mat couples wheel speed to robot speed
VelCouplingMat = [ForceVector; ones(1,4)];
InvVelCouplingMat = pinv(VelCouplingMat);

MatDelta = (InvForceCouplingMat - InvVelCouplingMat)./InvVelCouplingMat;

angle = linspace(0,2*pi,1000);
A = zeros(2,length(angle));

WheelRadius = 0.0254; %m
TorquePerCurrent = 25.5e-3; %Nm/A
PhaseResistance = 1.2; %Ohms
MaxV = 8.0;  %m/s
Mass = 2.48; %Kg
GearRatio = 0.5; %Unitless

for t = 1:length(angle)
	F = [cos(angle(t));sin(angle(t))];
	WheelForce = InvForceCouplingMat*[F;0];
	MotorTorque = WheelForce*WheelRadius*GearRatio;
	MotorVolts = MotorTorque/TorquePerCurrent*PhaseResistance;
	A(:,t) = F * MaxV/max(abs(MotorVolts)) / Mass;
end
