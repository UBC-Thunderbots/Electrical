#ifndef _MOTOR_H
#define _MOTOR_H

/**
*	@class Motor
*
*	A class representing a robot motor	
*
*/
class Motor {
	public:
		Motor();
		Motor(double timeStep);
		
		void setTimestep(double deltaTime);

		/**
		* sets the voltage available for the motors
		*
		* @param voltage the voltage available to the motors
		*
		*/
		void setVoltage(double voltage);
		
		/**
		*	performs a motor iteration
		* @param volage the drive power in volts
		*	@param velocity the motors linear velocity (m/s)
		* @return the linear force in Newtons
		*/
		double update(double voltage, double velocity);
	private:
		double motorSpeed;
		double current;
		double timeStep;
		double battVoltage;
		static const double INDUCTANCE;
		static const double RESISTANCE;
		static const double VOLTAGE_PER_SPEED;
		static const double GEAR_RATIO;
		static const double TORQUE_PER_AMPS;
		static const double WHEEL_RADIUS;
};
#endif
