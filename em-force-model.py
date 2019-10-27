import math;

# Purpose: Calculating the magnetic field strength at a point P, a certain distance away from the centre,
# along the axis to the direction the force is being exerted.
#
# Ampere’s law allows us to find the strength of a magnetic field (MF) within a solenoid, where the field is uniform.
# However, this does not apply outside the solenoid (at its edges).
# To find the MF strength at a point P outside the body of the solenoid, we use the following program.
#
# P is perpendicular to the cross section of the solenoid.
# This value is then used as an input to determine the electromagnetic force.

# For more information and referenced diagram (page598), https: // www.mdpi.com / 2076 - 3417 / 5 / 3 / 595 / pdf.All
# variables declarations used in this program are categorized into ...
# constants, values to be determined by design, values to be changed during play, output/calculated values

# Constants

mu = 4 * math.pi * pow(10, -7)  # permeability constant of free space


# Values determined by design, these being the parameters we can change by changing the design of the solenoid

lengthSolenoid = 10  # length of solenoid
outerDiameter = 14  # outer diameter of solenoid. This includes the width of the wires
innerDiameter = 8  # inner diameter of solenoid
shellCasingThickness = 7  # shell casing thickness (the frame we wrap wires around)
distPToCenter = 18  # distance from point P to center
numCoils = 100  # number of coils
crossSectionAreaSolenoid = pow((innerDiameter / 2 + shellCasingThickness), 2) * math.pi
# area calculation (cross section of solenoid)

# input values, these being values we can change during play, when we have finalized design
current = 25  # ### We want to use time as our input

# Preliminary Calculations

lineCurrentDensity: float = (current / lengthSolenoid) * numCoils  # this is used in the calculation for remanence
remanence = mu * lineCurrentDensity # remanent flux density (remanence)

constantMultiplier = (mu * numCoils * current) / (2 * lengthSolenoid * (outerDiameter - innerDiameter))
# this calculation for constantMultiplier is for debugging. It is an arbitrary value and have no meaning on its own


length_addDistanceFromCenter = lengthSolenoid + 2 * distPtoCenter

length_subtractDistanceFromCenter = lengthSolenoid - 2 * distPtoCenter

# The following are used for debugging purposes. They are arbitrary values and have no meaning in isolation
ln_termA = log((outerDiameter + sqrt(pow(outerDiameter, 2) + pow(length_addDistanceFromCenter, 2))) / (
            innerDiameter + sqrt(pow(innerDiameter, 2) + pow(length_addDistanceFromCenter, 2))))
ln_termB = log((outerDiameter + sqrt(pow(outerDiameter, 2) + pow(length_subtractDistanceFromCenter, 2))) / (
            innerDiameter + sqrt(pow(innerDiameter, 2) + pow(length_subtractDistanceFromCenter, 2))))

fieldStrengthAtP = constant_multiplier / differenceOuterInnerSolenoid * length_addDistanceFromCenter * math.log(ln_termA) + constant_multiplier / differenceOuterInnerSolenoid * length_subtractDistanceFromCenter * math.log(ln_termB)
