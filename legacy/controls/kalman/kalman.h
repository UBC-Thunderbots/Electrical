#include "util/kalman/matrix.h"
#include <deque>

#ifndef KALMAN_H_
#define KALMAN_H_

struct ControlInput
{
	ControlInput(double t, double v) : time(t), value(v) {}
	double time;
	double value;
};

class kalman {
	public:
		kalman();
		void predict_step(double timestep,double control, matrix& state_predict, matrix& P_predict) const;
		void predict(double prediction_time, matrix& state_predict, matrix& P_predict);
		matrix predict(double delta_time) const; // predict based on previous state estimate, no update is done on the Predict matrix
		void update(double measurement, double time);
		void new_control(double input,double time);


	private:
		double last_measurement_time;
		double last_control;
		double sigma_m;
		double sigma_a;
		std::deque<ControlInput> inputs;
		matrix gen_F_mat(double timestep) const;
		matrix gen_Q_mat(double timestep) const;
		matrix gen_G_mat(double timestep) const;
		matrix H;
		matrix P;
		matrix state_estimate;
};

#endif
