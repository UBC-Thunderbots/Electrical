function result = loadRobot_old(filename)
	values = importdata(filename,'\t',1);
	result.Epoch = values.data(:,1);
	result.Breakbeam = values.data(:,2);
	result.Capacitor = values.data(:,3);
	result.Battery = values.data(:,4);
	result.Boardtemp = values.data(:,5);
	result.LPS = values.data(:,6);
	result.Encoders = values.data(:,7:10);
	result.SetPoints = values.data(:,11:14);
	result.Outputs = values.data(:,15:18);
    result.MotorTemps = values.data(:,19:22);
    result.DribblerRPM = values.data(:,23);
    result.DribblerTemp = values.data(:,24);
    result.CPULoading = values.data(:,25);
end

