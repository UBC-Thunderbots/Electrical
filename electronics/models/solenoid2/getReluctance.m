function R = getReluctance(obj,position,flux)
		R = (obj.SOLENOID_LENGTH + position)/obj.MU_NOT./getMuR(obj,flux)/obj.SOLENOID_AREA + (obj.SOLENOID_LENGTH - position)/obj.MU_NOT/obj.SOLENOID_AREA;
end

