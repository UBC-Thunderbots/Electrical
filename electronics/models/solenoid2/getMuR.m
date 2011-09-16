function mu_r = getMuR(obj,flux)
		mu_r = (obj.MU_R_CORE-1)*(pi/2 - atan(100*(flux/obj.SOLENOID_AREA-obj.CORE_SATURATION)))/pi + 1;
end