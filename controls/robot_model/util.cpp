#include "util.h"
#include <cmath>

Vector3::Vector3() : x(0),y(0),theta(0) {
}

Vector3::Vector3(double x, double y, double theta): x(x),y(y), theta(theta) {
}

Vector3 Vector3::rotate(double angle) const {
	Vector3 temp;
	temp.x = x*cos(angle) - y*sin(angle);
	temp.y = x*sin(angle) + y*cos(angle);
	temp.theta = theta;
	return temp;
}

Vector3 Vector3::operator*(double value) const {
	Vector3 temp;
	temp.x = x*value;
	temp.y = y*value;
	temp.theta = theta*value;
	return temp;
}

Vector3 Vector3::operator*(const Vector3 &rightval) const {
	Vector3 temp;
	temp.x = x*rightval.x;
	temp.y = y*rightval.y;
	temp.theta = theta*rightval.theta;
	return temp;
}

Vector3 Vector3::operator/(double rightval) const {
	Vector3 temp;
	temp.x = x/rightval;
	temp.y = y/rightval;
	temp.theta = theta/rightval;
	return temp;
}

Vector3 Vector3::operator/(const Vector3 &rightval) const {
	Vector3 temp;
	temp.x = x/rightval.x;
	temp.y = y/rightval.y;
	temp.theta = theta/rightval.theta;
	return temp;
}

Vector3 Vector3::operator-=(const Vector3 &rightval) {
	*this += rightval*-1.0;
	return *this;
}

Vector3 Vector3::operator+=(const Vector3 &rightval) {
	x += rightval.x;
	y += rightval.y;
	theta += rightval.theta;
	return *this;
}

Vector3 Vector3::operator+(const Vector3 &rightval) const {
	Vector3 temp;
	temp.x = x+rightval.x;
	temp.y = y+rightval.y;
	temp.theta = theta+rightval.theta;
	return temp;
}

Vector3 Vector3::operator-(const Vector3 &rightval) const {
	return *this + (rightval*-1.0);
}
