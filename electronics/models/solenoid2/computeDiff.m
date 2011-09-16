function solenoidDiff = computeDiff(obj,time, state)
			
		velocity = state(1);
		position = state(2);
		flux = state(3);
		voltage = state(4);
			
		Reluctance = getReluctance(obj,position,flux);
		dReluctancedx = (1/getMuR(obj,flux) - 1)/obj.MU_NOT/obj.SOLENOID_AREA;
		dFlux = (obj.TURNS/obj.SOLENOID_RESISTANCE*voltage*obj.ALPHA - Reluctance*flux)/(obj.TURNS*obj.TURNS / obj.SOLENOID_RESISTANCE + obj.CORE_LOSS_CONSTANT);
		dVelocity = (-obj.DAMPING*velocity - 1/2*dReluctancedx*flux.^2)/obj.PLUNGER_MASS;
		dPosition = velocity;
		dVoltage = (obj.TURNS*dFlux - voltage)/obj.SOLENOID_RESISTANCE/obj.CAPACITOR_SIZE*obj.ALPHA;
			
		solenoidDiff = [dVelocity; dPosition; dFlux; dVoltage];
end

