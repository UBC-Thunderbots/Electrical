#include "motor.h"
#include <iostream>
const double Motor::INDUCTANCE = 0.56e-3;
const double Motor::RESISTANCE = 1.2;
const double Motor::VOLTAGE_PER_SPEED = 26.2e-3;
const double Motor::GEAR_RATIO = 3.5;
const double Motor::TORQUE_PER_AMPS = 25.5e-3;
const double Motor::WHEEL_RADIUS = 0.0254;


Motor::Motor() : motorSpeed(0.0),current(0.0), timeStep(1.0/200.0),battVoltage(17.0) {
}

Motor::Motor(double timeStep) : motorSpeed(0.0), current(0.0), timeStep(timeStep), battVoltage(17.0) {
}

void Motor::setTimestep(double deltaTime) {
	timeStep = deltaTime;
}

void Motor::setVoltage(double voltage) {
	battVoltage = voltage;
}

double Motor::update(double voltage,double velocity) {
	motorSpeed = velocity/WHEEL_RADIUS*GEAR_RATIO;
	voltage = (voltage > battVoltage)?battVoltage:voltage;
	voltage = (voltage < -1*battVoltage)?-1*battVoltage:voltage;

	double Veff = voltage - motorSpeed*VOLTAGE_PER_SPEED;
	
	current = (Veff - current * (RESISTANCE - INDUCTANCE/timeStep))/(INDUCTANCE/timeStep + RESISTANCE);
	//current = (voltage - motorSpeed*VOLTAGE_PER_SPEED)/RESISTANCE;
	return current*TORQUE_PER_AMPS*GEAR_RATIO/WHEEL_RADIUS;
}

