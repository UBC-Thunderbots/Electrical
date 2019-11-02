
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
# . values to be determined by design, values to be changed during play, output/calculated values
from typing import Dict
import scipy
from scipy import constants


# Values determined by design, these being the parameters we can change by
# changing the design of the solenoid

def em_force_model():
    
    #parameterList: Dict[str, Int]

    length_solenoid = 10  # length of solenoid
    outer_diameter = 14  # outer diameter of solenoid. This includes the width of the wires
    inner_diameter = 8  # inner diameter of solenoid
    # shell casing thickness (the frame we wrap wires around)
    shell_casing_thickness = 7
    dist_p__to_center = 18  # distance from point P to center
    num_coils = 100  # number of coils
    crossSectionArea_solenoid = scipy.power(
        (inner_diameter / 2 + shell_casing_thickness), 2) * scipy.pi
    # area calculation (cross section of solenoid)

    # External Values, changeable, but dependent on other components

    max_voltage = 4  # the voltage across the capacitor
    resistance = 1  # resistance of the device
    capacitance = 3  # capacitance of our capacitor

    # input values, these being values we can change during play, when we have
    # finalized design

    timeElapsed = 4  # ### we want to change length of pulse
    directionVector = 1

    # Preliminary Calculations

    timeConstant = resistance * capacitance

    maxCurrent = max_voltage / resistance

    current = maxCurrent * scipy.power(scipy.e, -timeElapsed / timeConstant)

    print(current)

    # this is used in the calculation for remanence
    lineCurrentDensity: float = (current / length_solenoid) * num_coils
    # remanent flux density (remanence)
    remanence = constants.mu_0 * lineCurrentDensity

    # The following are used for debugging purposes. They are arbitrary values
    # and have no meaning in isolation

    constantMultiplier = (constants.mu_0 * num_coils * current) / \
        (2 * length_solenoid * (outer_diameter - inner_diameter))

    length_addDistanceFromCenter = length_solenoid + 2 * dist_p_to_center

    length_subtractDistanceFromCenter = length_solenoid - 2 * dist_p_to_center

    ln_termA = scipy.log((outer_diameter +
                          scipy.sqrt(scipy.power(outer_diameter, 2) +
                                     scipy.power(length_addDistanceFromCenter, 2))) /
                         (inner_diameter +
                          scipy.sqrt(scipy.power(inner_diameter, 2) +
                                     scipy.power(length_addDistanceFromCenter, 2))))
    ln_termB = scipy.log((outer_diameter +
                          scipy.sqrt(scipy.power(outer_diameter, 2) +
                                     scipy.power(length_subtractDistanceFromCenter, 2))) /
                         (inner_diameter +
                          scipy.sqrt(scipy.power(inner_diameter, 2) +
                                     scipy.power(length_subtractDistanceFromCenter, 2))))

    # calculating field strength

    fieldStrengthAtP = constantMultiplier / length_addDistanceFromCenter * scipy.log(ln_termA) \
        + constantMultiplier / length_subtractDistanceFromCenter * scipy.log(ln_termB)
    print(fieldStrengthAtP)

    # calculating force

    forceOnPiston = fieldStrengthAtP * remanence * \
        crossSectionArea_solenoid * direction_vector / constants.mu_0  # r

    print(forceOnPiston)


if __name__ == "__main__":
    em_force_model()
