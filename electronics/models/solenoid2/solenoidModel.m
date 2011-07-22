classdef solenoidModel < handle
	properties
		FILL_FACTOR; %this is the circle fill factor (not nessecary at this point)
		AWG
		CLADDING_THICKNESS;
		WINDING_HEIGHT; %meters
		SOLENOID_WIDTH; % meters
		SOLENOID_HEIGHT; % meters
		SOLENOID_LENGTH; % in meters
		WINDING_RESISTIVITY; % ohm meters
		CAPACITOR_SIZE; % in farad
		CORE_RESISTIVITY; % ohm meter
		MU_NOT;
		MU_R_IRON;
		MU_R_STEEL;
		CORE_DENSITY; % kg / meters cube		
		ALPHA;
		
		CORE_DIAMETER;
		WIRE_DIAMETER;
		CORE_AREA;
		WINDING_AREA;
		TURNS;
		FILL_EFFICENCY;
		TURN_RESISTANCE;
		SOLENOID_RESISTANCE; 		
		SOLENOID_AREA; 
		MU_R_CORE;
		PLUNGER_MASS;
		CORE_LOSS_CONSTANT;

	end
	
	methods
		function model = solenoidModel()
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
		
		model.CORE_DENSITY = 7870; % kg / meters cubed
		model.PLUNGER_MASS = model.SOLENOID_AREA * model.SOLENOID_LENGTH * model.CORE_DENSITY;
		
		model.CORE_LOSS_CONSTANT = model.SOLENOID_LENGTH / (2* model.CORE_RESISTIVITY * (model.SOLENOID_WIDTH/model.SOLENOID_HEIGHT + model.SOLENOID_HEIGHT/model.SOLENOID_WIDTH));
		
		model.ALPHA = 1;
		end
	end
	
	methods
		function solenoidDiff = computeDiff(obj,t, state)
			
			velocity = state(1);
			position = state(2);
			flux = state(3);
			voltage = state(4);
			
			Reluctance = (obj.SOLENOID_LENGTH + position)/obj.MU_NOT/obj.MU_R_CORE/obj.SOLENOID_AREA + (obj.SOLENOID_LENGTH - position)/obj.MU_NOT/obj.SOLENOID_AREA;
			dReluctancedx = (1/obj.MU_R_CORE - 1)/obj.MU_NOT/obj.SOLENOID_AREA;
			dFlux = (obj.TURNS/obj.SOLENOID_RESISTANCE*voltage*obj.ALPHA - Reluctance*flux)/(obj.TURNS*obj.TURNS / obj.SOLENOID_RESISTANCE - obj.CORE_LOSS_CONSTANT);
			current = (obj.ALPHA*voltage - obj.TURNS * dFlux)/obj.SOLENOID_RESISTANCE;
			dVelocity = -(1 / (2 * obj.PLUNGER_MASS)) * dReluctancedx * obj.TURNS^2 / Reluctance^2 * current^2;
			dPosition = velocity;
			dVoltage = -current / obj.CAPACITOR_SIZE * obj.ALPHA;
			
			solenoidDiff = [dVelocity; dPosition; dFlux; dVoltage];
		end
	end
end