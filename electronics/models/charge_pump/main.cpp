#include <cmath>
#include <cassert>
#include <vector>
#include <iostream>
#include <fstream>


const double Vin = 12;
const double Vout_max = 240;
const unsigned int num_stages = 21;
const double Vd = 0.7;
const double Ct=5.4e-3;
const double Cs=220e-9;
const double f=220e3;
const double sim_time = 10;



double Voltage_start;
double Imax;
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
	std::vector<double> Vout;
	std::vector<double> I_max;
	std::vector<double> time;
	double cap_array[num_stages];

	for(unsigned int i=0;i<num_stages;++i) {
		cap_array[i]=Vin;
	}

	I.push_back(0);

	Vout.push_back(Vin);

	I_max.push_back(0);
	time.push_back(0);

	unsigned int loops = floor(f*2*sim_time);		

	bool changed = false;
	double I_av;
	double decrease_rate;
	double increase_rate;
	double Q;
	for(unsigned int index =0; index < loops ; ++index) {
		double charge=0;
		double current_voltage = *(Vout.end()-1);
		if(current_voltage<Vout_max) {
			for(unsigned int i=0;i<num_stages;++i) {
				if(i%2 == index%2) {
					cap_array[i] += Vin;
				} else {
					cap_array[i] -= Vin;
				}			
			}
			if((cap_array[0]+Vd) < Vin) {
				Q = (Vin - cap_array[0] - Vd)*Cs;
				charge += Q;
				cap_array[0] = Q/Cs;
			}	

			for(unsigned int i=1;i<num_stages;++i) {
				if(cap_array[i-1] > (cap_array[i] + Vd)) {
					double mean = (cap_array[i-1] + cap_array[i])/2;
					Q = (cap_array[i-1] - mean - Vd/2)*Cs;
					charge += Q;
					cap_array[i-1] -= Q/Cs;
					cap_array[i] += Q/Cs;
				} 
			}

			if(cap_array[num_stages-1] > (current_voltage + Vd)) {
				Q = (cap_array[num_stages-1]-Vd-current_voltage)*Cs;
				charge += Q;
				cap_array[num_stages-1] -= Q/Cs;
				current_voltage += Q/Ct;
			}
		}
		I.push_back(charge*f/2);
		Vout.push_back(current_voltage);
		time.push_back(*(time.end()-1)+1/f/2);
	}
	

	for(unsigned int index = 0; index < time.size(); ++index) {
		file << time[index] << "," << I[index] << "," << Vout[index] << std::endl;
	}
		file.close();
	return 0;
}
