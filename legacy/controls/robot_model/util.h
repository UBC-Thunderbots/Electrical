#ifndef __UTIL_H
#define __UTIL_H

class Vector3 {
	public:
		double x;
		double y;
		double theta;
		Vector3();
		Vector3(double,double,double);
		Vector3 rotate(double theta) const;
		Vector3 operator*(double) const;
		Vector3 operator*(const Vector3&) const;

		Vector3 operator/(const Vector3&) const;
		Vector3 operator/(double) const;

		Vector3 operator+=(const Vector3&);
		Vector3 operator-=(const Vector3&);

		Vector3 operator+(const Vector3&) const;
		Vector3 operator-(const Vector3&) const;
};

#endif
