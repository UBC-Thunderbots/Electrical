function model=solenoidModel()
		model.FILL_FACTOR = 0.9934; %this is the circle fill factor (not nessecary at this point)
		model.AWG = 18;
		
		model.CLADDING_THICKNESS = 0.0;
		model.CORE_DIAMETER = 1.27e-4 * (92 ^ ((36.0 - model.AWG) / 39.0));
		model.WIRE_DIAMETER =model. CORE_DIAMETER + 2*model.CLADDING_THICKNESS;
		model.CORE_AREA = (pi*model.CORE_DIAMETER*model.CORE_DIAMETER/4.0);
		
		model.WINDING_HEIGHT = 1e-2; %meters
		model.SOLENOID_WIDTH = 5e-2; % meters
		model.SOLENOID_HEIGHT = 5e-3; % meters
		model.SOLENOID_LENGTH = 5e-2; % in meters
		model.WINDING_AREA = model.SOLENOID_LENGTH * model.WINDING_HEIGHT;
		model.TURNS = floor(model.WINDING_AREA/(2*sqrt(2.5)*model.WIRE_DIAMETER*model.WIRE_DIAMETER))*4;
		model.FILL_EFFICENCY = model.TURNS * model.CORE_AREA / model.WINDING_AREA;
		
		model.WINDING_RESISTIVITY = 1.68e-8; % ohm meters
		model.TURN_RESISTANCE = model.WINDING_RESISTIVITY*(model.SOLENOID_LENGTH + model.SOLENOID_HEIGHT + 2*model.WINDING_HEIGHT)/model.CORE_AREA;
		model.SOLENOID_RESISTANCE = model.TURN_RESISTANCE * model.TURNS; % ohms
		
		model.SOLENOID_AREA = model.SOLENOID_HEIGHT * model.SOLENOID_WIDTH;  % in meters squared
		
		model.CAPACITOR_SIZE = 4.0e-3; % in farads
		
		model.CORE_RESISTIVITY = 7e-7; % ohm meters
		
		model.MU_NOT = 1.25663706e-6;
		model.MU_R_IRON = 5000;
		model.MU_R_STEEL = 300;
		model.MU_R_CORE = model.MU_R_STEEL;
		model.CORE_SATURATION = 1.6;
		
		model.CORE_DENSITY = 7870; % kg / meters cubed
		model.PLUNGER_MASS = model.SOLENOID_AREA * model.SOLENOID_LENGTH * model.CORE_DENSITY;
		
		model.CORE_LOSS_CONSTANT = model.SOLENOID_LENGTH / (2* model.CORE_RESISTIVITY * (model.SOLENOID_WIDTH/model.SOLENOID_HEIGHT + model.SOLENOID_HEIGHT/model.SOLENOID_WIDTH));
		
		model.DAMPING = 10;
		model.ALPHA = 1;
end
