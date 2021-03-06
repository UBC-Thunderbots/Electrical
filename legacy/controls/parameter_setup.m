FrontAngle=35;
BackAngle=45;

theta1= FrontAngle;
theta2= 180-FrontAngle;
theta3= 180+BackAngle;
theta4= 360-BackAngle;
%theta1 = 90 - FrontAngle;
%theta2 = 90 + BackAngle;
%theta3 = 270-BackAngle;
%theta4 = 270+FrontAngle;
Thetas = [theta1 theta2 theta3 theta4];

Max_Voltage = 15;
g = 9.81;
R = 0.09; %robot radius
wheel_radius= 0.0254; % wheel radius in meters
Mass = 4; % mass kg
alpha = 1/2; % cylindrical moment of inertia coefficient
GearRatio=1/3; %motor to wheels Velocity Scaling
DampingRatio=0.1*eye(4); %wheel velocity damping ration matrix


Coeff_Friction_Static=1;
Coeff_Friction_Dynamic=1;

WeightDistributionMatrix=1/4*ones(4,1);
Max_Force_Static=Mass*g*Coeff_Friction_Static*WeightDistributionMatrix;
Max_Force_Dynamic=Mass*g*Coeff_Friction_Dynamic*WeightDistributionMatrix;

RealMotor=0;   
TorqueGenerator=1;
MotorType=RealMotor; %use a real motor or a theoretical torque generator

Max_Current=2; %maximum motor current
Motor_Ra=1.2;  %Motor Resistance
Motor_La=0.56/1000; %Motor Inductance
Volt_to_RPM=374*GearRatio; %Motor Voltage to Wheel RPM
Amp_to_Torque=25.5/1000/GearRatio; %Motor Current to Wheel Torque
MotorTF = tf(1,[Motor_La Motor_Ra])*eye(4); %Voltage - back emf to current
Speed_to_RPM=60/(2*pi*wheel_radius); %linear wheel velocity to wheel rpm
Speed_to_Voltage=Speed_to_RPM/Volt_to_RPM; %linear wheel velocity to motor voltage

U_static = 0.75;
U_kinetic = 0.5;
N_force = Mass*g;
Friction_kinetic = U_kinetic * N_force;
Friction_static = U_static*Mass* N_force;

vel_coup_mat = [-sind(Thetas'), cosd(Thetas'), ones(size(Thetas'))]; %converts robot velocities to wheel velocities
inv_vel_coup_mat = pinv(vel_coup_mat);  %pseudoinverse of vel_coup_mat
Force_Coupling_Mat=1/Mass*[-sind(Thetas); cosd(Thetas); ones(size(Thetas))*1/alpha]; %converts wheel forces into robot accelerations

%vel_scale_mat=pinv(Force_Coupling_Mat);
vel_scale_mat=vel_coup_mat*[1 0 0;0 1 0; 0 0 wheel_radius]; %converts desired velocites to motor velocites

a_projection =  [ 0.2135; -0.2135; 0.2473; -0.2473 ]; % (I-DD*) take first row only
Slip_matrix =vel_coup_mat*pinv(vel_coup_mat);

Controller=1;
OpenLoop=0;
MotorControllerType=Controller; %decide to run in open loop or with motor controllers

MotorController=tf(3,1)*eye(4); %the motor Controller 



RobotLoopForward=Force_Coupling_Mat*tf(1,[1 0]);
RobotLoopBack=DampingRatio*vel_coup_mat;
RobotFull=feedback(RobotLoopForward,RobotLoopBack);

if MotorType > 0.5
    Motor=Speed_to_Voltage*RobotFull/wheel_radius*Amp_to_Torque/Motor_Ra;
else
    MotorForward=RobotFull/wheel_radius*Amp_to_Torque*MotorTF;
    MotorBack=Speed_to_Voltage*vel_coup_mat;
    Motor=Speed_to_Voltage*feedback(MotorForward,MotorBack);
end;

if(MotorControllerType > 0.5)
  Plant=feedback(Motor*MotorController,vel_coup_mat)*vel_scale_mat;
else
    Plant=Motor*vel_scale_mat;
end;

