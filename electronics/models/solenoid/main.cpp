#include <iostream>
#include <fstream>
#include <vector>

const unsigned int TURNS = 20000;
const double CAPACITOR_SIZE = 5.4e-3; // in farads
const double FILL_FACTOR = 0.9934;
const double WINDING_HEIGHT = 1e-2; //meters
const double SOLENOID_WIDTH = 5e-2; // meters
const double SOLENOID_HEIGHT = 5e-3; // meters
const double SOLENOID_LENGTH = 5e-2; // in meters
const double WINDING_AREA = SOLENOID_LENGTH * WINDING_HEIGHT;
const double WINDING_RESISTIVITY = 1.68e-8; // ohm meters
const double TURN_RESISTANCE = (SOLENOID_LENGTH*2 + 2*SOLENOID_HEIGHT)*WINDING_HEIGHT*WINDING_RESISTIVITY;
const double SOLENOID_AREA = SOLENOID_HEIGHT * SOLENOID_WIDTH;  // in meters squared
const double MU_NOT = 1.25663706e-6;
const double MU_R_IRON = 5000;
const double SOLENOID_RESISTANCE = TURN_RESISTANCE * TURNS; // ohms
const double CORE_DENSITY = 7870; // kg / meters cubed
const double SOLENOID_MASS = SOLENOID_AREA * SOLENOID_LENGTH * CORE_DENSITY;

const double CORE_RELUCTANCE = 2 * SOLENOID_LENGTH / SOLENOID_AREA / MU_NOT / MU_R_IRON;



const char SAVE_FILENAME[] = "data.csv"; 

const double SIM_TIME = 15e-3 ; // in seconds
const double TIMESTEP = 10e-7; // in seconds

std::fstream save_file;
std::vector<double> plunger_displacement; // in meters
std::vector<double> plunger_velocity;
std::vector<double> plunger_force;
std::vector<double> capacitor_voltage; // in volts
std::vector<double> solenoid_current;
std::vector<double> reluctance;
std::vector<double> inductance;
std::vector<double> times;

void save_row();

int main(void) {
	save_file.open(SAVE_FILENAME,std::fstream::out);		
	times.push_back(0);
	plunger_displacement.push_back(0);
	plunger_velocity.push_back(0);
	capacitor_voltage.push_back(240);
	solenoid_current.push_back(0);
	plunger_force.push_back(0);
	reluctance.push_back(SOLENOID_LENGTH/(MU_NOT * SOLENOID_AREA));
	inductance.push_back(TURNS / reluctance.back());
	save_row();

	//TODO: fix the code for the end of travel
	while(times.back() < SIM_TIME) {
		double force;
		double reluctance_temp;
		double voltage;
		double current;

		reluctance_temp =(SOLENOID_LENGTH - plunger_displacement.back())/(MU_NOT * SOLENOID_AREA) + (SOLENOID_LENGTH + plunger_displacement.back())/(MU_R_IRON * MU_NOT * SOLENOID_AREA);   
		reluctance_temp = (CORE_RELUCTANCE < reluctance_temp)?reluctance_temp:CORE_RELUCTANCE;
		reluctance.push_back(reluctance_temp);

		inductance.push_back(TURNS / reluctance.back());	

		voltage = capacitor_voltage.back() - solenoid_current.back() * TIMESTEP / CAPACITOR_SIZE;
		if(voltage < 0.0) {
			voltage = -0.7;
		}	
		capacitor_voltage.push_back( voltage );	
		
		current = solenoid_current.back() + (capacitor_voltage.back() - SOLENOID_RESISTANCE * solenoid_current.back() )/inductance.back()*TIMESTEP;	
		solenoid_current.push_back(current);
		
		force = TURNS * MU_NOT * SOLENOID_AREA * solenoid_current.back()*solenoid_current.back() / 4.0 / ((SOLENOID_LENGTH - plunger_displacement.back() + 2*SOLENOID_LENGTH/MU_R_IRON) * (SOLENOID_LENGTH - plunger_displacement.back() + 2*SOLENOID_LENGTH/MU_R_IRON)); 	
		
		if(plunger_displacement.back() > SOLENOID_LENGTH) {
			force = 0;
		}
	//`	force += -0.001*plunger_velocity.back();

		plunger_force.push_back(force);

		plunger_velocity.push_back(plunger_velocity.back() + force / SOLENOID_MASS * TIMESTEP);

		plunger_displacement.push_back(plunger_displacement.back() + plunger_velocity.back()*TIMESTEP);

		times.push_back(times.back() + TIMESTEP);

		save_row();
	}
	save_file.close();
}

void save_row() {
	save_file << plunger_displacement.back() << ";";	// 1
	save_file << plunger_velocity.back() << ";";			// 2
	save_file << plunger_force.back() << ";";					// 3
	save_file << capacitor_voltage.back() << ";";			// 4
	save_file << solenoid_current.back() << ";";			// 5
	save_file << reluctance.back() << ";";						// 6
	save_file << inductance.back() << ";";						// 7
	save_file << times.back() << std::endl;						// 8
}
