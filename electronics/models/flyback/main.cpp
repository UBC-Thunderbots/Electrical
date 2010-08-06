#include <cmath>
#include <cassert>
#include <vector>
#include <iostream>
#include <fstream>


const double Vin = 12;
const double Vout_max = 240;
const double transformer_ratio = 10;
const double Vd = 0.7;
const double L=2.5e-6;
const double C=5.4e-3;
const double Rpri = 7.7e-3;
const double Rsec = 515e-3;
const double f_max=415e3;
const double Ipk = 20;
const double D_P = 10;
const double D_margin = 0.98;
const double sim_time = 10;
const unsigned int pwm_levels = 1024;

double I_start;
double Voltage_start;
double Imax;
double I_end;
double Voltage_end;

int main(int argc, char* argv[]) {
	std::fstream file;
	if(argc == 2) {
		file.open(argv[1],std::fstream::out);
	} else {
		std::cout << "usage is boost_model savefile \n";
		return 0;
	}
	std::vector<double> I;
	std::vector<double> Iav;
	std::vector<double> Vout;
	std::vector<double> I_max;
	std::vector<double> Vsp;
	std::vector<double> Dlist;
	std::vector<double> time;
	std::vector<double> eff;

	I.push_back(0);
	Iav.push_back(0);

	Vout.push_back(0);

	I_max.push_back(0);
	time.push_back(0);
	Dlist.push_back(0);
	eff.push_back(0);

	unsigned int loops = round(f_max*sim_time);	
	
	

	double D;
	double D_1;
	double D_2;
	double f;
	double on_time;
	double off_time;
	double Dc;
	bool changed = false;
	bool controlled = false;
	double I_av;
	double decrease_rate;
	double increase_rate;
	double Ein;
	double Eout;

	for(unsigned int index =0; index < loops ; ++index) {
		I_start = *(I.end()-1);
		Voltage_start = *(Vout.end()-1);
		increase_rate = (Vin - I_start*Rpri)/L;
		increase_rate = (increase_rate < 0)?0:increase_rate;

		decrease_rate =  (Voltage_start + I_start/transformer_ratio*Rsec + Vd)/transformer_ratio/L;
		decrease_rate = (decrease_rate < 0)?0:decrease_rate;
	
		on_time = Ipk/increase_rate;
		off_time = Ipk/decrease_rate;

		D = on_time / (on_time + off_time);
		f = 1/(on_time + off_time);
		
		
			
		if(f > f_max || changed) {
			if(!changed) {
				std::cout << "Transistion Voltage: " << Voltage_start << std::endl;
			}
			changed = true;
			f = f_max;
			D = on_time*f;
		}

		Dc =	(Vout_max - Voltage_start)/Vout_max*D_P; 
		if(Dc < D || controlled) {
			if(!controlled) {
				std::cout << "beginning controlled at:" << std::endl;
				std::cout << "Frequency: " << f << std::endl;
				std::cout << "Voltage:   " << Voltage_start <<std::endl;
				std::cout << "Duty Cycle:" << D << std::endl;
				std::cout << "Sim Time:  " << *(time.end()-1) << std::endl;
			}
			controlled = true;
			D = Dc;
		}

		D = (D > 1)?1:D;
		D = (D < 0)?1:D;

		Imax = I_start + D/f*increase_rate;
		Ein = L*(D/f*increase_rate)*(D/f*increase_rate)/2;

		I_end = Imax - decrease_rate*(1-D)/f;	

		if(I_end < 0) {
			Voltage_end = Voltage_start + 0.5*Imax/transformer_ratio/C * Imax/decrease_rate;
			I_av = (Imax + I_start) / 2 * D + Imax/2 * Imax/decrease_rate * f; 
			I_end = 0;
		} else {
			Voltage_end = Voltage_start + (1-D)/f/C * (1.5*I_end + 0.5*Imax)/transformer_ratio;
			I_av = (I_start + Imax)/2 * D + (Imax + I_end)/2 *(1-D);
		}	
		Eout = C * (Voltage_end*Voltage_end - Voltage_start*Voltage_start)/2;
		
		eff.push_back(Eout/Ein);
		Dlist.push_back(D);
		Iav.push_back(I_av);
		I.push_back(I_end);
		I_max.push_back(Imax);
		
		Vout.push_back(Voltage_end);
		time.push_back(*(time.end()-1)+1/f);
		if(*(time.end()-1) > sim_time)
			break;
	}
	
	std::cout << "End sim, writing to disk" << std::endl;

	for(unsigned int index = 0; index < I.size(); ++index) {
		file << time[index] << "," << I[index] << "," << Iav[index] << "," << I_max[index] << "," << Vout[index] << "," << Dlist[index] << "'" << eff[index] <<std::endl;
	}
		file.close();
	return 0;
}
