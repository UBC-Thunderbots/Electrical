#include "matrix.h"
#include <vector>
#include <cmath>
#include <cstdlib>
#include <time.h>
#include "kalman.h"

//%standard deviation of the acceleration "noise"
const double astd = 2.0;

//%stanard deviation of the measurement "noise"
const double mstd = 1.3e-3;

//%length of time per step
const double timestep = 1.0/15.0;

//number of steps per simulation
const unsigned int steps = 1000;

int main(void) {
	srand(time(NULL));
	//%the state vector over time, both the kalman estimation and the real value
	matrix xreal(2,1000);
	matrix xguess(2,1000);
	double time[steps];
	
	for(unsigned int i = 0; i < steps; i++) {
		xreal(0,i)=0.0;
		xreal(1,i)=0.0;
		xguess(0,i)=0.0;
		xguess(1,i)=0.0;
		time[i]=0.0;
	}
	
	//%the state update matrix (get next state given current one
	//A=[1 timestep;0 1];
	matrix A(2,2);
	A(0,0) = 1;
	A(0,1) = timestep;
	A(1,0) = 0.0;
	A(1,1) = 1;
	
	//process noise gain
	matrix G(2,1);
	G(0,0) = timestep*timestep/2.0;
	G(1,0) = timestep;
	
	//%the state measurement operator
	//H=[1 0];
	matrix H(1,2);
	H(0,0)=1.0;
	H(0,1)=0.0;
	
 	kalman filter;
	
	for(unsigned index = 1; index < steps; index++) {
    	
		time[index] = time[index-1]+timestep;
		
		//%actual model run to simulate this time step
		double a = (rand()*1.0/RAND_MAX -0.5)*2.0*std::sqrt(3*astd*astd);
	  	matrix x1(A*xreal.sub(0,1,index-1,index-1) + G*a);
	  	xreal(0,index) = x1(0,0);
		xreal(1,index) = x1(1,0);
		
		//%take a measurement (camera frame)
		double measurement = xreal(0,index-1);//+ (rand()*1.0/RAND_MAX - 0.5)*2*std::sqrt(3*mstd*mstd);
		
		filter.new_control(a,time[index]);
		filter.update(measurement,time[index-1]);
		
		matrix guess(2,1);
		matrix guess_cov(2,2);
		filter.predict(time[index], guess, guess_cov);
		xguess(0,index) = guess(0,0);
		xguess(1,index) = guess(1,0);

		std::cout << xreal(0,index-1) << "  " << guess[0][0] << " " << xreal(1,index-1) << "  " << guess[1][0] << std::endl;
		
	}
	
	//std::cout << ~xguess << ~xreal << std::endl;
}
