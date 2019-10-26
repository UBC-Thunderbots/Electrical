import math

# purpose: Ampere’s law allows us to find the strength of a magnetic field (MF) within a solenoid, where the field is uniform. However, this does not apply outside the solenoid (at its edges). To find the MF strength at a point outside the body of the solenoid, we use the following program. This value is then used as an input to determine the electromagnetic force.

#For more information, visit: https: // www.mdpi.com / 2076 - 3417 / 5 / 3 / 595 / pdf, or
#http: // spiff.rit.edu / classes / phys313 / lectures / sol / sol_f01_long.html.All variables
#declarationsused in this programare consistent with the links above and categorized into 3 sections: constants.

# Restricted/Max Values
# length of solenoid
L = 10
# outer diameter of solenoid. This includes the width of the wires
D = 14
# inner diameter of solenoid
d = 8
# shell casing thickness. This does not include the width of the wires
a = 7

# constants
# input values
# current
i = 25
# distance to center
zp = 18
# number of coils
N = 100
# area calculation (cross section of solenoid)
A = pow((d / 2 + a), 2) * math.pi

# permeability constant of free space
mu = 4 * math.pi * pow(10, -7)

# Calculated values used as inputs
# line current density (current in each wire/length of solenoid)*number of coils
Js = (i / L) * N
# remanent flux density a.k.a remanence
Br = mu * Js

# outputs

#outputs: Bsol_z

constant_multiplier = (mu*N*i)/(2*L)

differenceOuterInnerSolenoid = D - d

length_DddDistancefromCenter = L + 2*zp

length_subtract_distance_from_center = L - 2*zp

#Used for debugging
ln_termA = (D + math.sqrt(pow(D, 2)+pow(L + 2*zp, 2)))/(d + math.sqrt((pow(d, 2)+pow(L + 2*zp, 2))))
ln_termB = (D + math.sqrt(pow(D, 2)+pow(L-2*zp, 2)))/(d + math.sqrt(pow(d, 2)+pow(L-2*zp, 2)))

BsolZ = constant_multiplier/differenceOuterInnerSolenoid*length_addDistancefromCenter*math.log(ln_termA) + constant_multiplier/differenceOuterInnerSolenoid*length_subtractDistancefromCenter*math.log(ln_termB)


# force of rod
Fz = (Br * BsolZ * A) / mu

print(BsolZ)
print(Fz)
