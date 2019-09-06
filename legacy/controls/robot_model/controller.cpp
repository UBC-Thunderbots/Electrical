#include "controller.h"
#include <cstring>


Controller::Controller() :size(1),state(NULL),A(NULL),B(NULL) {
	createVectors();
}

Controller::~Controller() {
	destroyVectors();
}

void Controller::setSize(int newSize) {
	size = newSize;
	createVectors();		
}

void Controller::createVectors() {
	if(A || B || state)
		destroyVectors();

	A = new double[size];
	B = new double[size];
	state = new double[size];

	for(int i=0;i<size;i++) {
		state[i]=0;
		A[i]=0.0;
		B[i]=0.0;
	}
	A[0]=1.0;
	B[0]=1.0;
}

void Controller::destroyVectors() {
	delete[] A;
	delete[] B;
	delete[] state;
	A = NULL;
	B = NULL;
	state = NULL;
}

double Controller::tick(double setpoint,double feedback) {
	double output =0;
	double newstate = setpoint-feedback;
	
	for(int i=1;i<size;i++) {
		state[i] = state[i-1];
		output += B[i]*state[i];
		newstate -= A[i]*state[i];
	}

	output += newstate*B[0];
	state[0] = newstate;
	return output;
}
