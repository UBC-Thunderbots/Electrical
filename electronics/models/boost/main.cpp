#include <cmath>
#include <cassert>
#include <vector>
#include <iostream>
#include <fstream>

const char filename[] = "values.csv";

const double Vin = 14.8;
const double Vout_max = 240;
const double Vd = 0.7;
const double Dmax = 1 - Vin/Vout_max;
const double L=47e-6;
const double C=5.4e-3;
const double R=34e-3;
const double f=25e3;
const double Ipk_target = 6;
const unsigned int iters = 100;
const double charge_time = 5;
const double sim_time = 10;

double I_start;
double Voltage_start;
double Imax;
double I_end;
double Voltage_end;

int main(void) {
	std::vector<double> I;
	std::vector<double> Vout;
	std::vector<double> I_max;
	std::vector<double> Vsp;
	std::vector<double> Dlist;
	std::vector<double> time;

	I.push_back(0);
	Vout.push_back(Vin);
	I_max.push_back(0);
	time.push_back(0);

	unsigned int loops = floor(f*sim_time);	
	
	Vsp.push_back(Vin);
	double increase = (Vout_max-Vin)/charge_time/f;
	for(unsigned int index = 0;index< loops;++index) {
			if(index/f < charge_time) {
				Vsp.push_back(*(Vsp.end()-1)+increase);
			} else {
				Vsp.push_back(*(Vsp.end()-1));
			}
	}
	

	double D;
	double decrease_rate;
	double increase_rate;

	for(std::vector<double>::iterator voltage_sp = Vsp.begin(); voltage_sp != Vsp.end();++voltage_sp) {
		I_start = *(I.end()-1);
		Voltage_start = *(Vout.end()-1);

		//D = 1 - Vin / *voltage_sp;
		if(Voltage_start < Vout_max) {
			D = Ipk_target * L * f / Vin;
		} else {
			D = 0;
		}

		D = (D > 1)?1:D;
		D = (D<0)?0:D;
		increase_rate = (Vin - I_start*R)/L;
		decrease_rate =  (Vin - Voltage_start - I_start*R - Vd)/L;
		
		Imax = I_start + D/f*increase_rate;

		I_end = Imax + decrease_rate*(1-D)/f;	
		if(I_end < 0) {
			Voltage_end = Voltage_start + 0.5*Imax/C * Imax/fabs(decrease_rate);
			I_end = 0;
		} else {
			Voltage_end = Voltage_start + (1-D)/f/C * (1.5*I_end + 0.5*Imax);
		}	

		I.push_back(I_end);
		I_max.push_back(Imax);
		
		Vout.push_back(Voltage_end);
		time.push_back(*(time.end()-1)+1/f);
	}
	

	for(unsigned int index = 0; index < I.size(); ++index) {
		std::cout << time[index] << "," << I[index] << "," << I_max[index] << "," << Vsp[index] << "," << Vout[index] << std::endl;
	}
	
	return 0;
}
