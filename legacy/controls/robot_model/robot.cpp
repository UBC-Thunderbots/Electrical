#include "robot.h"
#include <cmath>
#include <iostream>

const double PI = 4.0*atan(1.0);

const double Robot::RADIUS = 0.09;
const double Robot::MASS = 6.0;
const double Robot::INERTIA = Robot::MASS * Robot::RADIUS * Robot::RADIUS / 2.0;

//Idealized robot
//const double Robot::ANGLES[4] = {45.0, 135.0, 225.0, 315.0};

//our robot
const double Robot::ANGLES[4] = {57.0, 135.0, 225.0, 303.0};

const double Robot::CONTROL_P = 9.25;
const double Robot::CONTROL_I = 3.2814;
const double Robot::CONTROL_D = 0.0;
 
const double Robot::FORCE_MATRIX[4][3] = {{-2.0908,2.3967,0.0763},{-1.7628,-2.3967,0.0587},{1.7628,-2.3967,0.0587},{2.0908,2.3967,0.0763}};

const Vector3 Robot::MASSES(Robot::MASS,Robot::MASS,Robot::INERTIA);
const double Robot::BATT_VOLTAGE = 17.0;
const double Robot::WHEEL_RADIUS = 0.0254;
const double Robot::VOLTS_PER_FORCE = 0.3415;
const double Robot::VOLTS_PER_SPEED = 3.5183;

Robot::Robot() : timeStep(1.0/200.0) , angleOffset(0) ,limiterEnabled(false), controlEnabled(false), compensateEnabled(false) {
	for(int i=0;i<4;i++) {
		motors[i].setTimestep(timeStep);
		controllers[i].setConstants(CONTROL_P,CONTROL_I,CONTROL_D);
	}	
}

Robot::Robot(double timeStep) : timeStep(timeStep) , angleOffset(0),limiterEnabled(false), controlEnabled(false), compensateEnabled(false) {
	for(int i=0;i<4;i++) {
		motors[i].setTimestep(timeStep);
		controllers[i].setConstants(CONTROL_P,CONTROL_I,CONTROL_D);
	}	
}

void Robot::setTimestep(double deltatime) {
	timeStep = deltatime;
	for(int i =0 ;i<4;i++) {
		motors[i].setTimestep(deltatime);
	}
}

Vector3 Robot::getPosition() {
	return position;
}

void Robot::tick() {
	static int i=0;

		//rotate setpoint by new amount
	Vector3 compensated;
	if(compensateEnabled) {
		compensated = setPoint.rotate(angleOffset);
	} else {
		compensated = setPoint;
	}

	//transform to wheel setpoints
	double wheels[4];
	double wheelSpeed[4];

	double factor = 20.0;
	
	Vector3 accDir = (compensated-speed.rotate(-position.theta))*factor;

	//take in 3 vector and output wheel speeds in m/s
	//getWheels(wheels,compensated);
	getWheels(wheelSpeed,speed.rotate(-position.theta));


	//take desired acceleration and compute needed wheel force
	accToForce(accDir,wheels);	

	//apply limiter to convert wheel force to motor voltage
	//if(limiterEnabled)
	limiter(wheels,wheelSpeed);
	
	//tick wheel controller
	//apply to motors
	for(int i=0;i<4;i++) {
		std::cout << wheels[i] << ";";
		//Jog the motor by setting the voltage and getting the force
		wheels[i] = motors[i].update(wheels[i],wheelSpeed[i]);
	}
	//std::cout << std::endl;
	//accumulate to the robots 3force from the individual motor ground force
	//forces is x force, y force, theta torque
	Vector3 forces = getForce(wheels);

	//increment robot relative Velocity from the 3force vector
	speed += forces.rotate(position.theta)/MASSES*timeStep;

	//integrate global position from robot speed
	position += speed*timeStep;
	
	//update angleOffset
	angleOffset -= speed.theta*timeStep;
}

void Robot::getWheels(double *wheels,Vector3 vels) {
	for(int i=0;i<4;i++) {
		wheels[i] = (cos(ANGLES[i]/2.0/PI)*vels.y - sin(ANGLES[i]/2.0/PI)*vels.x + RADIUS*vels.theta);
	}
}


//take in a vector of wheel linear force
void Robot::limiter(double *wheels,double *wheelSpeed) {
	int max_wheel=0;
	double max_value=0;
	double headroom;
	double scale;
	for(int i = 0;i < 4;i++) {
		double temp = std::fabs(wheels[i]*VOLTS_PER_FORCE + wheelSpeed[i]*VOLTS_PER_SPEED);
		if(temp > max_value) {
			max_value = temp;
			max_wheel = i;
		}
	}
	
	//checks for same or opposite direction
	if(wheels[max_wheel]*wheelSpeed[max_wheel] > 0) {
		headroom = BATT_VOLTAGE - std::fabs(wheelSpeed[max_wheel])*VOLTS_PER_SPEED;
	} else {
		headroom = std::fabs(wheelSpeed[max_wheel])*VOLTS_PER_SPEED + BATT_VOLTAGE;
	}

	if(max_value > BATT_VOLTAGE) {
		if(headroom > 0) {
			scale = headroom / (VOLTS_PER_FORCE*std::fabs(wheels[max_wheel]));
		} else {
			scale = 0.0;
		}
	} else {
		scale = 1.0;
	}
	
	for(int i=0;i<4;i++) {
			wheels[i] = scale*wheels[i]*VOLTS_PER_FORCE + wheelSpeed[i]*VOLTS_PER_SPEED;	
	}


}

void Robot::accToForce(Vector3 acc,double *forces) {
		
	for(int i=0;i<4;i++) {
		forces[i] = FORCE_MATRIX[i][0]*acc.x +FORCE_MATRIX[i][1]*acc.y +FORCE_MATRIX[i][2]*acc.theta;    
	}
}

Vector3 Robot::getForce(double* forces) {
	Vector3 temp;
	for(int i=0;i<4;i++) {
		temp.x -= sin(ANGLES[i]/2.0/PI)*forces[i];
		temp.y += cos(ANGLES[i]/2.0/PI)*forces[i];
		temp.theta += forces[i]*RADIUS; 
	}
	return temp;
}

double Robot::setSetPoint(Vector3 vels) {
	setPoint = vels;
	angleOffset = 0.0;
}

void Robot::setControl(bool toggle) {
	controlEnabled = toggle;
}

void Robot::setLimiter(bool toggle) {
	limiterEnabled = toggle;
}

void Robot::setCompensate(bool toggle) {
	compensateEnabled = toggle;
}
