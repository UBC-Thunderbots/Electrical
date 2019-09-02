#include "robot.h"
#include "util.h"

#include <cmath>
#include <iostream>

const double TIMESTEP = 1.0/200.0;

int main(void) {
	Robot A(TIMESTEP);
	//A.setControl(true);
	//A.setCompensate(true);
	for(int i =0;i<2000;i++) {
		Vector3 temp=A.getPosition();
		Vector3 Sp(0.0,0.0,4.0);
		if( (i%13) == 0) {
			A.setSetPoint((Sp-A.getPosition()).rotate(-temp.theta));
		}
		A.tick();
		std::cout << temp.x << ";" << temp.y <<";" << temp.theta <<std::endl;
	}
	return 0;
}
