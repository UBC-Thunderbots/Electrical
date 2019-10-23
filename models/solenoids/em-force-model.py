import math;

#constants

mu = 4*math.pi*pow(10, -7);
N = 100 #number of coils


#Experimental values
Br = 192
L = 10 #length of solenoid
D = 14 #outer diameter of solenoid. This includes the width of the wires
d = 8 #inner diameter of solenoid
a = 7 #shell casing thickness. This does not include the width of the wires

#input values
i = 25 #current
zp = 18 #distance to center

#area calculation (cross section of solenoid)
A = pow((d/2+a), 2)*math.pi

#outputs

Bs = ((mu*N*i)*(L+2*zp)*math.log((D+math.sqrt(pow(D, 2)+pow(L+2*zp, 2)))/(d+math.sqrt(pow(d, 2)+pow(L+2*zp, 2)))))/(2*L*(D-d)) + ((mu*N*i)*(L-2*zp)*math.log((D+math.sqrt(pow(D, 2)+pow(L-2*zp, 2)))/(d+math.sqrt(pow(d, 2)+pow(L-2*zp, 2)))))/(2*L*(D-d))

a = (mu*N*i)*(L+2*zp)*math.log((D+math.sqrt(pow(D, 2)+pow(L+2*zp, 2)))/(d+math.sqrt(pow(d, 2)+pow(L+2*zp, 2))))

print(a)
