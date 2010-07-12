#include <cmath>
#include <cassert>
#include <vector>
#include <iostream>
#include <fstream>


const double Vin = 12;
const double Vout_max = 240;
const unsigned int num_stages = 10;
const double Vd = 0.7;
const double Ct=5.4e-3;
const double Cs=220e-9;
const double f=68e3;
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

	I.push_back(0);

	Vout.push_back(Vin);

	I_max.push_back(0);
	time.push_back(0);

	unsigned int loops = floor(f*sim_time);		

	bool changed = false;
	double I_av;
	double decrease_rate;
	double increase_rate;
	for(unsigned int index =0; index < loops ; ++index) {

		I.push_back(0);
		
		Vout.push_back(0);
		time.push_back(*(time.end()-1)+1/f);
	}
	

	for(unsigned int index = 0; index < I.size(); ++index) {
		file << time[index] << "," << I[index] << "," << Vout[index] << std::endl;
	}
		file.close();
	return 0;
}
