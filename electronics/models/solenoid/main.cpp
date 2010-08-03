#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

const double FILL_FACTOR = 0.9934; //this is the circle fill factor (not nessecary at this point)

const unsigned int AWG = 22;

const double CLADDING_THICKNESS = 0.0;
const double CORE_DIAMETER = 1.27e-4 * pow(92,(36.0-AWG)/39.0);
const double WIRE_DIAMETER = CORE_DIAMETER + 2*CLADDING_THICKNESS;
const double CORE_AREA = (M_PI*CORE_DIAMETER*CORE_DIAMETER/4.0);

const double WINDING_HEIGHT = 1e-2; //meters
const double SOLENOID_WIDTH = 5e-2; // meters
const double SOLENOID_HEIGHT = 5e-3; // meters
const double SOLENOID_LENGTH = 5e-2; // in meters
const double WINDING_AREA = SOLENOID_LENGTH * WINDING_HEIGHT;
const unsigned int TURNS = floor(WINDING_AREA/(2*sqrt(2.5)*WIRE_DIAMETER*WIRE_DIAMETER))*4;
const double FILL_EFFICENCY = TURNS * CORE_AREA / WINDING_AREA;


//TODO: this needs to take into account the extra wire as the windings get thicker
const double WINDING_RESISTIVITY = 1.68e-8; // ohm meters
const double TURN_RESISTANCE = WINDING_RESISTIVITY*(SOLENOID_LENGTH*2 + 2*SOLENOID_HEIGHT)/CORE_AREA;
const double SOLENOID_RESISTANCE = TURN_RESISTANCE * TURNS; // ohms


const double SOLENOID_AREA = SOLENOID_HEIGHT * SOLENOID_WIDTH;  // in meters squared


//Sise of the capacitor storing the kicker charge
const double CAPACITOR_SIZE = 5.4e-3; // in farads
const double CAPACITOR_INITAL_CHARGE = 240; // in volts

const double MU_NOT = 1.25663706e-6;
const double MU_R_IRON = 5000;

const double CORE_DENSITY = 7870; // kg / meters cubed
const double PLUNGER_MASS = SOLENOID_AREA * SOLENOID_LENGTH * CORE_DENSITY;

const char SAVE_FILENAME[] = "data.csv"; 

const double SIM_TIME = 15e-3 ; // in seconds
const double TIMESTEP = 10e-7; // in seconds

std::fstream save_file;
std::vector<double> plunger_displacement; // in meters
std::vector<double> plunger_velocity;
std::vector<double> plunger_force;
std::vector<double> capacitor_voltage; // in volts
std::vector<double> solenoid_current;
std::vector<double> inductance;
std::vector<double> times;

void save_row();

int main(void) {
	std::cout << "CONSTANT calculations: " << std::endl;
	std::cout << "CORE DIAMETER:         " << CORE_DIAMETER*1000 << "(mm)" << std::endl;
	std::cout << "WIRE DIAMETER:         " << WIRE_DIAMETER*1000 << "(mm)" << std::endl;
	std::cout << "CORE AREA:             " << CORE_AREA*1000*1000 << "(mm^2)" << std::endl;
	std::cout << "WINDING AREA:          " << WINDING_AREA*1000*1000 << "(mm^2)" << std::endl;
	std::cout << "TURNS:                 " << TURNS << std::endl;
	std::cout << "FILL EFFICENCY:        " << FILL_EFFICENCY*100 << "%" << std::endl;
	std::cout << "TURN RESISTANCE:       " << TURN_RESISTANCE << "(ohm)" << std::endl;
	std::cout << "SOLENOID RESISTANCE    " << SOLENOID_RESISTANCE << "(ohm)" << std::endl;
	std::cout << "SOLENOID AREA          " << SOLENOID_AREA*1000*1000 << "(mm^2)" << std::endl;
	std::cout << "PLUNGER MASS           " << PLUNGER_MASS *1000 << "(grams)" << std::endl;
	
	save_file.open(SAVE_FILENAME,std::fstream::out);		
	times.push_back(0);
	plunger_displacement.push_back(0);
	plunger_velocity.push_back(0);
	capacitor_voltage.push_back(CAPACITOR_INITAL_CHARGE);
	solenoid_current.push_back(0);
	plunger_force.push_back(0);
	inductance.push_back(TURNS * TURNS * MU_NOT * SOLENOID_AREA/SOLENOID_LENGTH);
	save_row();

	//TODO: fix the code for the end of travel
	while(times.back() < SIM_TIME) {
		double force;
		double voltage;
		double current;


		inductance.push_back(TURNS * TURNS * MU_NOT * SOLENOID_AREA * (SOLENOID_LENGTH + (MU_R_IRON - 1)*plunger_displacement.back()) / (SOLENOID_LENGTH * SOLENOID_LENGTH));	

		voltage = capacitor_voltage.back() - solenoid_current.back() * TIMESTEP / CAPACITOR_SIZE;
		if(voltage < 0.0) { // assume a diode snubber
			voltage = -0.7;
		}	
		capacitor_voltage.push_back( voltage );	
		
		current = solenoid_current.back() + (capacitor_voltage.back() - SOLENOID_RESISTANCE * solenoid_current.back() )/inductance.back()*TIMESTEP;	
		solenoid_current.push_back(current);
		
		force = TURNS * TURNS * MU_NOT * SOLENOID_AREA * ( MU_R_IRON - 1) * solenoid_current.back() * solenoid_current.back() / (SOLENOID_LENGTH * SOLENOID_LENGTH); 	
		
		if(plunger_displacement.back() > SOLENOID_LENGTH) {
			force = 0;
		}

		plunger_force.push_back(force);
		plunger_velocity.push_back(plunger_velocity.back() + force / PLUNGER_MASS * TIMESTEP);
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
	save_file << inductance.back() << ";";						// 6
	save_file << times.back() << std::endl;						// 7
}
