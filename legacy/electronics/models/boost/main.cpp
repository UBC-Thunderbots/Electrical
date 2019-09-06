#include <cmath>
#include <cassert>
#include <vector>
#include <iostream>
#include <fstream>



const double Vin = 17;
const double Vout_max = 240;
const double Vd = 0.7;
const double L=22e-6;
const double C=5.4e-3;
const double Rpri = 14.6e-3;
const double Rsec = 14.6e-3;
const double f=68e3;
const double sim_time = 10;
const double D_P = 100;
const double D_margin = 0.90;
const double Ipk = 10;
const unsigned int pwm_levels = 128;

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

	I.push_back(0);
	Iav.push_back(0);
	Vout.push_back(Vin);
	I_max.push_back(0);
	time.push_back(0);
	Dlist.push_back(0);

	unsigned int loops = floor(f*sim_time);	
	
	

	double D;
	double D_1;
	double D_2;
	bool changed = false;
	double I_av;
	double decrease_rate;
	double increase_rate;
	for(unsigned int index =0; index < loops ; ++index) {
		// Setting iterator to last value
		I_start = *(I.end()-1);
		Voltage_start = *(Vout.end()-1);

		//Get di/dt for when switch is on
		increase_rate = (Vin - I_start*Rpri)/L;
		increase_rate = (increase_rate < 0)?0:increase_rate;

		//Get di/dt for when switch is off
		decrease_rate =  (Vin - Voltage_start - I_start*Rsec- Vd)/L;
		decrease_rate = (decrease_rate > 0)?0:decrease_rate;
		
		//Actual Duty Cycle
		D_1 = decrease_rate/(decrease_rate - increase_rate)*D_margin;

		//Theoretical Duty Cycle set point
		D_2 = (Vout_max - Voltage_start)/Vout_max*D_P;	
		D_2 = floor(D_2*pwm_levels)/pwm_levels;

		if(D_1 < 0.5/pwm_levels) {
			D_1 = Ipk * f * L / Vin;	
		}

		D_1 = floor(D_1*pwm_levels)/pwm_levels;
		
		if(D_2 < D_1 && !changed) {
			changed = true;
			std::cout << "Transition Voltage: " << Voltage_start << std::endl;
			std::cout << "Duty: " << D_2 << std::endl;
		}

		if(changed) {
			D = D_2;
		} else {
			D = D_1;
		}

		D = (D > 1)?1:D;
		D = (D<0)?0:D;
	
		if(I_start > 0.1)
			D=0;

		Dlist.push_back(D);
		
		Imax = I_start + D/f*increase_rate;

		I_end = Imax + decrease_rate*(1-D)/f;	

		if(I_end < 0) {
			Voltage_end = Voltage_start + 0.5*Imax/C * Imax/fabs(decrease_rate);
			I_av = (Imax + I_start) / 2 * D + Imax/2 * Imax/fabs(decrease_rate) * f; 
			I_end = 0;
		} else {
			Voltage_end = Voltage_start + (1-D)/f/C * (1.5*I_end + 0.5*Imax);
			I_av = (I_start + Imax)/2 * D + (Imax + I_end)/2 *(1-D);
		}	
		Iav.push_back(I_av);
		I.push_back(I_end);
		I_max.push_back(Imax);
		
		Vout.push_back(Voltage_end);
		time.push_back(*(time.end()-1)+1/f);
	}
	

	for(unsigned int index = 0; index < I.size(); ++index) {
		file << time[index] << "," << I[index] << "," << Iav[index] << "," << I_max[index] << "," << Vout[index] << "," << Dlist[index] << std::endl;
	}
		file.close();
	return 0;
}
