#include <cassert>
#include <cmath>
#include <sstream>
#include <gsl/gsl_cblas.h>
#include <gsl/gsl_linalg.h>
#include "util/kalman/matrix.h"

// reference pages:
// http://www.gnu.org/software/gsl/manual/html_node/GSL-CBLAS-Examples.html
// http://www.prism.gatech.edu/~ndantam3/cblas-doc/doc/html/cblas_8h.html#7d42dfcb6073c56391fee28494809cc5
// doxygen

//TODO dimension check
//TODO fix toString method, make it more secure

using namespace std;

matrix::matrix(): m(NULL) {
}

matrix::matrix(unsigned int size_i, unsigned int size_j, double* data){	
	m = gsl_matrix_alloc(size_i,size_j);
	if( data != NULL ){
		for( unsigned int num = 0; num < size_i*size_j; num++){
			m->data[num] = data[num];
		}
	}
}

matrix::matrix(const matrix &B) {
	m = gsl_matrix_alloc(B.m->size1,B.m->size2);
	gsl_matrix_memcpy(m,B.m);
}

// this one is private
matrix::matrix(gsl_matrix* mat):m(mat){
}

matrix::~matrix() {
	if(m != NULL){
		gsl_matrix_free(m);
	}
}

unsigned int matrix::i(){
	return this->m->size1;
}

unsigned int matrix::j(){
	return this->m->size2;
}

matrix matrix::reset(){
	gsl_matrix_set_zero(this->m);
	return *this; //TODO iffy about memory leak/ dangling pointer
}

matrix matrix::identity( unsigned int n ) {
	gsl_matrix* m = gsl_matrix_alloc(n,n);
	gsl_matrix_set_identity(m);
	matrix temp(m);
	return temp;
}


std::string matrix::toString(){
	ostringstream oss(ostringstream::out);
	for( unsigned int i = 0; i < m->size1; i++){
		for(unsigned int j = 0; j < m->size2; j++){
			oss << m->data[i*m->size2+j] << " ";
		}
		oss << endl;
	}
	return oss.str(); //TODO mem leak
}


matrix matrix::sub(unsigned int begin_i,unsigned int end_i,unsigned int begin_j,unsigned int end_j) const {
	unsigned int size_i = end_i-begin_i+1;
	unsigned int size_j = end_j-begin_j+1;
	assert(begin_i >= 0 );
	assert(begin_j >= 0 );
	assert(size_i > 0);
	assert(size_j > 0);
	assert(end_i < this->m->size1 );
	assert(end_j < this->m->size2 );
	gsl_matrix * mat = gsl_matrix_alloc(size_i, size_j);
	_gsl_matrix_view temp = gsl_matrix_submatrix( this->m, begin_i, begin_j, size_i, size_j );
	gsl_matrix_memcpy(mat,&temp.matrix);
	matrix wanted(mat);
	return wanted;
}

/*matrix matrix::sub(unsigned int begin_i,unsigned int begin_j,unsigned int size_i,unsigned int size_j) const {
	assert(begin_i < this->m->size1 );
	assert(begin_j < this->m->size2 );
	assert(begin_i + size_i -1 < this->m->size1 );
	assert(begin_j + size_j -1 < this->m->size2 );
	gsl_matrix * mat = gsl_matrix_alloc(size_i,size_j);
	_gsl_matrix_view temp = gsl_matrix_submatrix( this->m, begin_i, begin_j, size_i, size_j );
	gsl_matrix_memcpy(mat,&temp.matrix);
	matrix wanted(mat);
	return wanted;
}*/

/*matrix matrix::sub(unsigned int size_i,unsigned int end_i,unsigned int size_j,unsigned int end_j) const {
	assert(size_i <= end_i+1 );
	assert(size_j <= end_j+1 );
	assert(end_i < this->m->size1 );
	assert(end_j < this->m->size2 );	
	unsigned int begin_i = end_i-size_i+1;
	unsigned int begin_j = end_j-size_j+1;
	assert(begin_i >= 0 );
	assert(begin_j >= 0 );
	assert(size_i > 0);
	assert(size_j > 0);
	gsl_matrix * mat = gsl_matrix_alloc(size_i, size_j);
	_gsl_matrix_view temp = gsl_matrix_submatrix( this->m, begin_i, begin_j, size_i, size_j );
	gsl_matrix_memcpy(mat,&temp.matrix);
	matrix wanted(mat);
	return wanted;
}*/

// return transpose with out changing content
matrix matrix::operator~() {
	matrix temp;	
	if(is_square()){
		temp = *this; // TODO figure out constructor
		gsl_matrix_transpose(temp.m);
	} else {
		gsl_matrix* mat = gsl_matrix_alloc(this->m->size2,this->m->size1);
		for(unsigned int i = 0; i< this->m->size1;i++){
			for(unsigned int j = 0; j<this->m->size2; j++){
				gsl_matrix_set(mat,j,i,  gsl_matrix_get(this->m, i,j));
			}
		}
		temp.m = mat;
	}
	return temp;
}

matrix matrix::operator=(const matrix &B) {
	// clean this object
	if(m != NULL){
		gsl_matrix_free(m);
	}
	
	// reallocate space
	m = gsl_matrix_alloc(B.m->size1,B.m->size2);
	
	// create data copy
	gsl_matrix_memcpy(m,B.m);
	
	return *this; // TODO what's this?
}

matrix matrix::operator!() {
	assert( this->m->size1 == this->m->size2 );
	gsl_matrix* A = gsl_matrix_alloc(this->m->size1, this->m->size2);
	gsl_matrix_memcpy(A, this->m);
	gsl_permutation* p = gsl_permutation_alloc (this->m->size1);
	int signum;
	gsl_linalg_LU_decomp(A, p, &signum);
	gsl_matrix* C = gsl_matrix_alloc(this->m->size1, this->m->size2);
	gsl_linalg_LU_invert(A, p, C);
	matrix ret(C);
	return ret; 
}

double& matrix::operator()(unsigned int i, unsigned int j){
	assert(i < this->m->size1);
	assert(j < this->m->size2);
	assert(i*this->m->size2+j < this->m->size1*this->m->size2);
	return this->m->data[i*this->m->size2+j];
}

double matrix::operator()(unsigned int i , unsigned int j) const{
	assert(i < this->m->size1);
	assert(j < this->m->size2);
	assert(i*this->m->size2+j < this->m->size1*this->m->size2);
	return this->m->data[i*this->m->size2+j];
}

/*matrix matrix::merge(const matrix &A, const matrix &B, const matrix &C, const matrix &D) const {
	assert(A.n == B.n);
	assert(A.m == C.m);
	assert(B.m == D.m);
	assert(C.n == D.n);
	matrix ret(A.n+C.n,A.m+B.m,precision);

	for(unsigned int i=0;i < ret.n;i++)
		for(unsigned int j = 0; j < ret.m;j++) {
			if(i < A.n) {
				if(j < A.m) {
					ret(i,j) = A(i,j);
				} else {
					ret(i,j) = B(i,j-A.m);
				}
			} else {
				if(j < A.m) {
					ret(i,j) = C(i-A.n,j);
				} else {
					ret(i,j) = D(i-A.n,j-A.m);
				}
			}
		}

	return ret;
}*/



matrix operator*(double A, const matrix& B) {
	return B*A;
}

matrix matrix::operator*(double A) const {
	gsl_matrix* mat = gsl_matrix_alloc(this->m->size1,this->m->size2);
	gsl_matrix_memcpy(mat,this->m);
	gsl_matrix_scale(mat, A);
	matrix temp(mat);
	return temp;
}

matrix matrix::operator/(double A) const {
	gsl_matrix* mat = gsl_matrix_alloc(this->m->size1,this->m->size2);
	gsl_matrix_memcpy(mat,this->m);
	gsl_matrix_scale(mat, 1/A);
	matrix temp(mat);
	return temp;
}

matrix matrix::operator*(const matrix &B) const {
	assert( this->m->size2 == B.m->size1 );
	gsl_matrix* mat = gsl_matrix_alloc(this->m->size1, B.m->size2);
	cblas_dgemm (CblasRowMajor, 
		CblasNoTrans, CblasNoTrans, 
		this->m->size1 , B.m->size2 , this->m->size2,
		1.0, 
		this->m->data, this->m->size2, 
		B.m->data, B.m->size2, 
		0.0, 
		mat->data, mat->size2);

	matrix C(mat);
	return C;
}

matrix matrix::operator+(const matrix &B) const {
	assert(this->m->size1 == B.m->size1);
	assert(this->m->size2 == B.m->size2);
	gsl_matrix* mat = gsl_matrix_alloc(this->m->size1,this->m->size2);
	gsl_matrix_memcpy(mat, this->m);
	gsl_matrix_add(mat, B.m);
	matrix C(mat);
	return C;
}

matrix matrix::operator-(const matrix &B) const {
	assert(this->m->size1 == B.m->size1);
	assert(this->m->size2 == B.m->size2);
	gsl_matrix* mat = gsl_matrix_alloc(this->m->size1,this->m->size2);
	gsl_matrix_memcpy(mat, this->m);
	gsl_matrix_sub(mat, B.m);
	matrix C(mat);
	return C;
}

/*std::ostream& operator<<(std::ostream& out, const matrix &A) {
	for(unsigned int i=0;i<A.n;i++) {
		for(unsigned int j=0;j<A.m;j++) {
			out << A(i,j) << DELIMITER;
		}
		out << std::endl;
	}
	return out;
}*/
