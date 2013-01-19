#include <iostream>
#include <string>
#include <gsl/gsl_matrix.h>

#ifndef MATRIX_H
#define MATRIX_H

//const char DELIMITER = ';';
// i denot row and j denote column

class matrix {
	public:
		matrix(); // this one initialize m to null. 
		matrix(unsigned int size_i,unsigned int size_j=1, double* data=NULL); // if there is data, we will store it in an extra copy. 2) gsl initialize value to zero. 3) user is responsible for the correct size of the array
		matrix(const matrix &B);
		~matrix();
		/*old modified*/ static matrix identity(unsigned int n);
		/*new method*/ // matrix set_identity(

		unsigned int i();
		unsigned int j();

		matrix reset(); // reset and return itself
		
		
		class row {
			matrix& parent;
			unsigned int i;
			public:
				row(matrix& p, unsigned int row_number): parent(p), i(row_number){};
				double operator[](unsigned int j){return gsl_matrix_get(parent.m,i,j);};
		};

		row operator[](unsigned int i){ return row(*this, i);}; //TODO more dimension checks
		double& operator()(unsigned int, unsigned int);
		double operator()(unsigned int, unsigned int) const;

		std::string toString();
		
		matrix operator+(const matrix &B) const;
		matrix operator-(const matrix &B) const;

		matrix operator*(const matrix &B) const;
		matrix operator*(double) const;
		matrix operator/(double) const;
		friend matrix operator*(double, const matrix&);

		matrix operator=(const matrix &B);

		matrix operator~(); //transpose
		matrix operator!();

		//matrix merge(const matrix &,const matrix &,const matrix &,const matrix &) const;    
		matrix sub(unsigned int begin_i,unsigned int end_i,unsigned int begin_j,unsigned int end_j) const;
		//matrix sub(unsigned int begin_i,unsigned int begin_j,unsigned int size_i,unsigned int size_j) const;
		//matrix sub(unsigned int size_i,unsigned int end_i,unsigned int size_j,unsigned int end_j) const;
		 // TODO sub assign mutator
		
		
		//friend std::ostream& operator<<(std::ostream& out,const matrix &A);
		

	private:
		friend class row;

		matrix(gsl_matrix* mat); // internal use

		gsl_matrix* m;
		inline bool is_square(){ return (m!=NULL && m->size1==m->size2); };
};

/*

class matrix {
	public:
		matrix();
		matrix(unsigned int n,unsigned int m=1,unsigned int precision=default_precision);
		matrix(const matrix &B);
		static matrix identity(unsigned int n, unsigned int precision=default_precision);
		mpf_class& operator()(unsigned int, unsigned int);
		mpf_class operator()(unsigned int, unsigned int) const;
		
		matrix operator+(const matrix &B) const;
		matrix operator-(const matrix &B) const;

		matrix operator*(const matrix &B) const;
		matrix operator*(const mpf_class&) const;
		matrix operator/(const mpf_class&) const;
		matrix operator*(double) const;
		matrix operator/(double) const;
		friend matrix operator*(const mpf_class&,matrix&);
		friend matrix operator*(double, const matrix&);

		matrix operator=(const matrix &B);

		matrix operator~();
		matrix operator!();

		matrix merge(const matrix &,const matrix &,const matrix &,const matrix &) const;    
		matrix sub(unsigned int,unsigned int,unsigned int,unsigned int) const;
		
		~matrix();
		
		friend std::ostream& operator<<(std::ostream& out,const matrix &A);
		

	private:
		unsigned int n;
		unsigned int m;
		unsigned int precision;
		mpf_class* data;
};
*/
#endif
