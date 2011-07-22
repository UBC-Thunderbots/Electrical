initVelocity = 0;
initPosition = 0;
initFlux = 0;
initVoltage = 240;

initState = [initVelocity; initPosition; initFlux; initVoltage];

[t, y] = ode45(@solenoidDiff, [0, 0.004], initState);

for i = 1:4
	subplot(2,2,i);
	plot(t, y(:,i));
end;
