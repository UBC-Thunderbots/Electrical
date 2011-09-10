clear;
load moded.csv
Voltage = moded(:,2);
Time = moded(:,1);
DownSample = 50;
Capacitance = 4e-3;
DownVoltage = decimate(Voltage,DownSample);
Ts = mean(diff(Time))*DownSample;
DownTime = downsample(Time,50);
Resistance = 0.2337;


DownCurrent = [diff(DownVoltage)/Ts*-Capacitance;0];

PowerInput = DownVoltage.*DownCurrent;
PowerLoss = Resistance*DownCurrent.^2;
PowerDelivered = PowerInput-PowerLoss;
plot(DownTime,PowerInput);
hold on
plot(DownTime,PowerLoss,'g');
plot(DownTime,PowerDelivered,'m');