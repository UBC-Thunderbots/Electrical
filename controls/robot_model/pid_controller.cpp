#include "pid_controller.h"

PIDController::PIDController() {
	setConstants(1.0,0.0,0.0);
}

double PIDController::tick(double setpoint, double feedback) {
	return Controller::tick(setpoint,feedback);
}

void PIDController::setConstants(double P, double I,double D) {
	setSize(3);
	A[0]=1.0;
	A[1]=-1.0;
	A[2]=0.0;
	
	B[0] = P + I + D;
	B[1] = -P -2*D;
	B[2] = D;
}
