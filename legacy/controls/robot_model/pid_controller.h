#ifndef _PID_CONTROLLER_H
#define _PID_CONTROLLER_H
#include "controller.h"

class PIDController : protected Controller {
	public:
		PIDController();
		void setConstants(double P,double I,double D);
		double tick(double,double);
};
#endif
