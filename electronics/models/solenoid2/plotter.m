initVelocity = 0;
initPosition = 0;
initFlux = 0;
initVoltage = 240;

initState = [initVelocity; initPosition; initFlux; initVoltage];

A = solenoidModel();

[t, y] = ode45(@(t,y) computeDiff(A,t,y), [0, 0.005], initState);

figure(1);
for i = 1:4
	subplot(2,2,i);
	plot(t, y(:,i));
end;

figure(2);
VelEnergy = A.PLUNGER_MASS/2*y(:,1).^2;
CapEnergy = A.CAPACITOR_SIZE/2*y(:,4).^2;
MagEnergy = getReluctance(A,y(:,2),y(:,3))/2.*(y(:,3).^2);
subplot(2,2,1)
plot(t,VelEnergy);
subplot(2,2,2)
plot(t,VelEnergy+MagEnergy+CapEnergy);
subplot(2,2,3)
plot(t,MagEnergy);
subplot(2,2,4)
plot(t,CapEnergy);

figure(3)
plot(t,y(:,3)/A.SOLENOID_AREA);
