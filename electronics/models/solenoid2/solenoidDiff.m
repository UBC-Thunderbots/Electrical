function solenoidDiff = solenoidDiff(t, state)
	FILL_FACTOR = 0.9934; %this is the circle fill factor (not nessecary at this point)
	AWG = 18;
	
	CLADDING_THICKNESS = 0.0;
	CORE_DIAMETER = 1.27e-4 * (92 ^ ((36.0 - AWG) / 39.0));
	WIRE_DIAMETER = CORE_DIAMETER + 2*CLADDING_THICKNESS;
	CORE_AREA = (pi*CORE_DIAMETER*CORE_DIAMETER/4.0);

	WINDING_HEIGHT = 1e-2; %meters
	SOLENOID_WIDTH = 5e-2; % meters
	SOLENOID_HEIGHT = 5e-3; % meters
	SOLENOID_LENGTH = 5e-2; % in meters
	WINDING_AREA = SOLENOID_LENGTH * WINDING_HEIGHT;
	TURNS = floor(WINDING_AREA/(2*sqrt(2.5)*WIRE_DIAMETER*WIRE_DIAMETER))*4;
	FILL_EFFICENCY = TURNS * CORE_AREA / WINDING_AREA;
	
	WINDING_RESISTIVITY = 1.68e-8; % ohm meters
	TURN_RESISTANCE = WINDING_RESISTIVITY*(SOLENOID_LENGTH + SOLENOID_HEIGHT + 2*WINDING_HEIGHT)/CORE_AREA;
	SOLENOID_RESISTANCE = TURN_RESISTANCE * TURNS; % ohms

	SOLENOID_AREA = SOLENOID_HEIGHT * SOLENOID_WIDTH;  % in meters squared

	%Size of the capacitor storing the kicker charge
	CAPACITOR_SIZE = 4.0e-3; % in farads
    
	CORE_RESISTIVITY = 7e-7; % ohm meters
    
	MU_NOT = 1.25663706e-6;
	MU_R_IRON = 5000;
	MU_R_STEEL = 300;
	MU_R_CORE = MU_R_STEEL;

	CORE_DENSITY = 7870; % kg / meters cubed
	PLUNGER_MASS = SOLENOID_AREA * SOLENOID_LENGTH * CORE_DENSITY;
	
	CORE_LOSS_CONSTANT = SOLENOID_LENGTH / (2* CORE_RESISTIVITY * (SOLENOID_WIDTH/SOLENOID_HEIGHT + SOLENOID_HEIGHT/SOLENOID_WIDTH)); 
  
	ALPHA = 1;
	
	fprintf('%d\n',PLUNGER_MASS);
	
	velocity = state(1);
	position = state(2);
	flux = state(3);
	voltage = state(4);

	Reluctance = (SOLENOID_LENGTH + position)/MU_NOT/MU_R_CORE/SOLENOID_AREA + (SOLENOID_LENGTH - position)/MU_NOT/SOLENOID_AREA;
	dReluctancedx = (1/MU_R_CORE - 1)/MU_NOT/SOLENOID_AREA;
	dFlux = (TURNS/SOLENOID_RESISTANCE*voltage*ALPHA - Reluctance*flux)/(TURNS*TURNS / SOLENOID_RESISTANCE - CORE_LOSS_CONSTANT);
	current = (ALPHA*voltage - TURNS * dFlux)/SOLENOID_RESISTANCE;
	dVelocity = -(1 / (2 * PLUNGER_MASS)) * dReluctancedx * TURNS^2 / Reluctance^2 * current^2;
	dPosition = velocity;
	dVoltage = -current / CAPACITOR_SIZE * ALPHA;
	
	solenoidDiff = [dVelocity; dPosition; dFlux; dVoltage];
end
