#ifndef _ROBOT_H
#define _ROBOT_H
#include "pid_controller.h"
#include "motor.h"
#include "util.h"

class Robot {
	public:
		Robot();
		Robot(double timeStep);
		void setTimestep(double);
		void tick();
		void setControl(bool);
		void setLimiter(bool);
		void setCompensate(bool);
		double setSetPoint(Vector3 vels);
		Vector3 getPosition();

	private:
		void getWheels(double* ,Vector3);
		void limiter(double*,double*);
		void accToForce(Vector3 acc,double*);
		Vector3 getForce(double*);
		double timeStep;
		double angleOffset;
		bool limiterEnabled;
		bool controlEnabled;
		bool compensateEnabled;
		Vector3 setPoint;
		Vector3 speed;
		Vector3 position;
		double motorspeeds[4];
		Motor motors[4];
		PIDController controllers[4];
		static const double ANGLES[4];
		static const Vector3 MASSES;
		static const double RADIUS;
		static const double MASS;
		static const double INERTIA;
		static const double BATT_VOLTAGE;
		static const double CONTROL_P;
		static const double CONTROL_I;
		static const double CONTROL_D;
		static const double FORCE_MATRIX[4][3];
		static const double WHEEL_RADIUS;
		static const double VOLTS_PER_FORCE;
		static const double VOLTS_PER_SPEED;
};

#endif
