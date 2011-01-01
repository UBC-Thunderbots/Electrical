#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

const double FILL_FACTOR = 0.9934; //this is the circle fill factor (not nessecary at this point)

const unsigned int AWG = 18;

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
const double TURN_RESISTANCE = WINDING_RESISTIVITY*(SOLENOID_LENGTH + SOLENOID_HEIGHT + 2*WINDING_HEIGHT)/CORE_AREA;
const double SOLENOID_RESISTANCE = TURN_RESISTANCE * TURNS; // ohms


const double SOLENOID_AREA = SOLENOID_HEIGHT * SOLENOID_WIDTH;  // in meters squared


//Size of the capacitor storing the kicker charge
const double CAPACITOR_SIZE = 5.4e-3; // in farads
const double CAPACITOR_INITIAL_CHARGE = 240; // in volts

const double MU_NOT = 1.25663706e-6;
const double MU_R_IRON = 5000;
const double MU_R_STEEL = 300;
const double MU_R_CORE = MU_R_STEEL;

const double CORE_DENSITY = 7870; // kg / meters cubed
const double PLUNGER_MASS = SOLENOID_AREA * SOLENOID_LENGTH * CORE_DENSITY;

const double SOLENOID_CONSTANT = MU_NOT * TURNS * TURNS * SOLENOID_AREA / (SOLENOID_LENGTH * SOLENOID_LENGTH);

const char SAVE_FILENAME[] = "data.csv"; 

const double SIM_TIME = 15e-3 ; // in seconds
const double TIMESTEP = 10e-7; // in seconds

std::fstream save_file;
std::vector<double> displacement; // in meters
std::vector<double> voltage; // in volts
std::vector<double> times; // in seconds

void save_row();
double inductance(double);

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
	std::cout << "SOLENOID CONSTANT      " << SOLENOID_CONSTANT << "(m Kg / s^2 / A^2)" << std::endl;
	
	save_file.open(SAVE_FILENAME,std::fstream::out);		
	
	//initialize the system
	times.push_back(0);
	times.push_back(TIMESTEP);
	displacement.push_back(0);
	displacement.push_back(0);
	voltage.push_back(CAPACITOR_INITIAL_CHARGE);
	voltage.push_back(CAPACITOR_INITIAL_CHARGE);
	
	save_row();
	bool exited=false;

	//TODO: need better models for the end of travel
	//TODO: add code to account for eddy loss in the core

	while(times.back() < SIM_TIME) {

		if(!exited && displacement.back() > SOLENOID_LENGTH) {
			break;
		}
		
		double xc = displacement.back();
		double xp = *(displacement.end()-2);
		double vc = voltage.back();
		double vp = *(voltage.end()-2);
		double xf = xc;
		double vf = vc;	
		
		double a1 = PLUNGER_MASS/TIMESTEP/TIMESTEP/TIMESTEP;
		double a2 = (2*xc*xp - xp*xp);
		double a3 = CAPACITOR_SIZE/2/TIMESTEP;
		double a4 = -CAPACITOR_SIZE*CAPACITOR_SIZE/4/TIMESTEP/TIMESTEP;
		double a5 = -inductance(xc)*CAPACITOR_SIZE*CAPACITOR_SIZE/2/TIMESTEP/TIMESTEP/TIMESTEP;
		double a6 = -2*vc*vp - vp*vp;
		
		double J;	
		do {
		 	J = (a1*(xf*xf-2*xc*xf+a2) - a3*(vf-vp) - a4*(vf*vf - 2*vp*vf + vp*vp) - a5*(vf*vf - vc*vf + a6));
			J = J*J;
			double dJ_dv = 2*(-a3 - 2*a4*vf + a4*2*vp - a5*2*vf + a5*vc)*sqrt(J);
			double dJ_dx = 2*(2*a1*xf - a1*2*xc)*sqrt(J);
			vf = 1e-20 * -J/dJ_dv;
			xf = 1e-20 * -J/dJ_dx;
			std::cout << J <<std::endl;	
		} while(J > 1e-6);
	
		
		voltage.push_back(vf);
		displacement.push_back(xf);
		times.push_back(times.back() + TIMESTEP);

		save_row();
	}
	save_file.close();
}


double inductance(double x) {
		double reluctance = SOLENOID_LENGTH/MU_NOT/MU_R_CORE/SOLENOID_AREA + (SOLENOID_LENGTH - x)/MU_NOT/SOLENOID_AREA;
		return	TURNS*TURNS/reluctance; 
}

void save_row() {
	save_file << displacement.back() << ";";  // 1
	save_file << voltage.back() << ";";       // 2
	save_file << times.back() << std::endl;   // 3
}
