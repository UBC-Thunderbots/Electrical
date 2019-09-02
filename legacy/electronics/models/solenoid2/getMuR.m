function mu_r = getMuR(obj,flux)
	B = flux/obj.SOLENOID_AREA;
	Scale = obj.CORE_SAT_SCALE;
	Bsat = obj.CORE_SATURATION;
	mu_f = obj.MU_R_CORE;
	if(abs(B) < 1e-9)
		mu_r = mu_f;
	else
		H = (1-mu_f)/mu_f*atan(B*Scale/Bsat)*Bsat/Scale + B;
		mu_r = B./H;
	end;
end