#include "util/kalman/kalman.h"
#include <time.h>

kalman::kalman() : H(matrix(1,2)), P(matrix::identity(2)), state_estimate(matrix(2,1)) {
	state_estimate(0,0) = 0.0;
	state_estimate(1,0) = 0.0;
	sigma_m = 1.3e-3;
	sigma_a = 2.0;
	//%the state measurement operator
	//H=[1 0];(;
	H(0,0) = 1.0;
	H(0,1) = 0.0;
	last_measurement_time = 0.0;
	last_control = 0.0;
}

matrix kalman::gen_G_mat(double timestep) const {
	//%the acceleration to state vector (given an acceleration, what is the state
	//%update)
	//G=[timestep.^2/2; timestep];
	matrix G(2,1);
	G(0,0) = timestep*timestep/2;
	G(1,0) = timestep;
	return G;
	
}

matrix kalman::gen_Q_mat(double timestep) const {
	matrix G = gen_G_mat(timestep);
	//%The amount of uncertainty gained per step
	matrix Q(G*~G*sigma_a*sigma_a);
	return Q;
}

matrix kalman::gen_F_mat(double timestep) const {
	//%the state update matrix (get next state given current one
	//F=[1 timestep;0 1];
	matrix F(2,2);
	F(0,0) = 1.0;
	F(0,1) = timestep;
	F(1,0) = 0.0;
	F(1,1) = 1.0;
	return F;
}

//predict forward one step
void kalman::predict_step(double timestep, double control, matrix& state_predict, matrix& P_predict) const {
	matrix F = gen_F_mat(timestep);
	matrix G = gen_G_mat(timestep);
	matrix Q = gen_Q_mat(timestep);
	state_predict = F*state_predict + G*control;
	P_predict = F*P_predict*~F + Q;
}

// get convient prediction without updating prediction matrix
matrix kalman::predict(double delta_time) const {
	matrix F = gen_F_mat(delta_time);
	
	return F*state_estimate;
}

//get an estimate of the state at prediction_time
void kalman::predict(double prediction_time, matrix& state_predict, matrix& P_predict) {
	double current_time = last_measurement_time;
	double current_control = last_control;
	
	for (std::deque<ControlInput>::iterator inputs_itr = inputs.begin();
			inputs_itr != inputs.end() && (*inputs_itr).time < prediction_time; ++inputs_itr) {
		predict_step((*inputs_itr).time - current_time, current_control, state_predict, P_predict);
		current_time = (*inputs_itr).time;
		current_control = (*inputs_itr).value;
	}
	predict_step(prediction_time - current_time, current_control, state_predict, P_predict);
}

//this should generate an updated state, as well as clean up all the inputs since the last measurement
//until this current one
void kalman::update(double measurement, double measurement_time) {
	matrix state_priori(state_estimate);
	matrix P_priori(P);
	predict(measurement_time, state_priori, P_priori);
	
	//%how much does the guess differ from the measurement
	double residual = measurement - (H*state_priori)(0,0);
    
	//%The kalman update calculations
	matrix Kalman_gain = (P_priori*~H)/(((H*P_priori*~H)(0,0)) + sigma_m*sigma_m);
	matrix x2(state_priori + Kalman_gain*residual);
	
	state_estimate(0,0) = x2(0,0);
	state_estimate(1,0) = x2(1,0);

	P = (matrix::identity(2) - Kalman_gain*H)*P_priori;
	last_measurement_time = measurement_time;
	
	//we should clear the control inputs for times before last_measurement_time because they are unneeded
	//and we don't want memory to explode
	while (!inputs.empty() && inputs.front().time <= last_measurement_time) {
		last_control = inputs.front().value;
		inputs.pop_front();
	}
}

void kalman::new_control(double input, double input_time) {
	// the new control input overwrites all actions that were scheduled for later times
	// this allows us, for instance, to change our mind about future control sequences
	while (!inputs.empty() && inputs.back().time >= input_time) {
		inputs.pop_back(); 
	}
	if (input_time <= last_measurement_time)
		last_control = input;
	else
		inputs.push_back(ControlInput(input_time, input));
}
