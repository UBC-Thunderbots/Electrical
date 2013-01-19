#ifndef __CONTROLLER_H
#define __CONTROLLER_H
class Controller {
	public:
		Controller();
		virtual ~Controller();
		void setSize(int size);
		virtual double tick(double,double);
	protected:
		unsigned int size;
		double *state;
		double *A;
		double *B;
	private:
		void createVectors();
		void destroyVectors();
};

#endif
