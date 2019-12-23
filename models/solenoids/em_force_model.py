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
import matplotlib.pyplot as plt
import numpy as np


# Values determined by design, these being the parameters we can change by
# changing the design of the solenoid

def input_values():
    parameter_list = {
        'length_solenoid': 10,  # length of solenoid
        'outer_diameter': 14,  # outer diameter of solenoid. This includes the width of the wires
        'inner_diameter': 8,  # inner diameter of solenoid
        # shell casing thickness (the frame we wrap wires around)
        'shell_casing_thickness': 7,
        'dist_p_to_center': 18,  # distance from point P to center
        'num_coils': 100,  # number of coils

        # External Values, changeable, but dependent on other components

        'max_voltage': 4,  # the voltage across the capacitor
        'resistance': 1,  # resistance of the device
        'capacitance': 3,  # capacitance of our capacitor

        # input values, these being values we can change during play, when we have
        # finalized design

        'total_time': 5.,  # the time frame we wish to look at
        'time_interval': 0.2,  # ### we want to change length of pulse
        'direction_vector': 1,

    }
    return parameter_list


def em_force_model(parameter_list):
    # Preliminary Calculations
    cross_section_area_solenoid = scipy.power(
        (parameter_list['inner_diameter'] / 2 + parameter_list['shell_casing_thickness']), 2) * scipy.pi,
    # area calculation (cross section of solenoid)
    time_constant = parameter_list['resistance'] * parameter_list['capacitance']

    max_current = parameter_list['max_voltage'] / parameter_list['resistance']

    # The following are used for debugging purposes. They are arbitrary values and have no meaning in isolation

    #    for i in range(0, parameter_list['total_time']):
    #       current_at_t.append(current(max_current, time_elapsed, time_constant))
    #      i+time_elapsed

    # calling calculate_remanence function
    # remanence = calculate_remanence(current, parameter_list['length_solenoid'], parameter_list['num_coils'])

    # calling calculate_constant_multiplier function
    # constant_multiplier = calculate_constant_multiplier(parameter_list['num_coils'], current,
    #                                                    parameter_list['length_solenoid'],
    #                                                   parameter_list['outer_diameter'],
    #                                                    parameter_list['inner_diameter'])

    length_add_distance_from_center = parameter_list['length_solenoid'] + 2 * parameter_list['dist_p_to_center']

    length_subtract_distance_from_center = parameter_list['length_solenoid'] - 2 * parameter_list['dist_p_to_center']

    # calling calculate_ln_term_a function
    ln_term_a = calculate_ln_term_a(parameter_list['outer_diameter'], length_add_distance_from_center,
                                    parameter_list['inner_diameter'])

    # calling calculate_ln_term_b function
    ln_term_b = calculate_ln_term_b(parameter_list['outer_diameter'],
                                    length_subtract_distance_from_center,
                                    parameter_list['inner_diameter'])

    # calling calculating_field_strength function
    # field_strength_at_p = calculate_field_strength_at_p(constant_multiplier, length_add_distance_from_center,
    #                                                    ln_term_a, length_subtract_distance_from_center, ln_term_b)

    # print(field_strength_at_p)

    # calculating force
    # force_on_piston = calculate_force_on_piston(field_strength_at_p,
    #                                            remanence, cross_section_area_solenoid,
    #                                           parameter_list['direction_vector'])

    # print(force_on_piston)

    time_elapsed = np.arange(0., parameter_list['total_time'], parameter_list['time_interval'])

    # plt.plot(time_elapsed, current(max_current, time_elapsed, time_constant), 'b--')

    plt.plot(time_elapsed, calculate_field_strength_at_p(calculate_constant_multiplier(parameter_list['num_coils'],
                                                                                       current(max_current,
                                                                                               time_elapsed,
                                                                                               time_constant),
                                                                                       parameter_list[
                                                                                           'length_solenoid'],
                                                                                       parameter_list['outer_diameter'],
                                                                                       parameter_list[
                                                                                           'inner_diameter']),
                                                         length_add_distance_from_center,
                                                         ln_term_a,
                                                         length_subtract_distance_from_center,
                                                         ln_term_b),
             'b--')

    plt.show()


##

# FUNCTIONS TO BE CALLED FROM MAIN FUNCTION
# THIS WAS DONE TO REDUCE CLUTTER IN THE MAIN FUNCTION AND TO CREATE LESS COMPLEX UNIT TEST CASES FOR THE FUNCTIONS

##

def current(max_current, time_elapsed, time_constant):
    cur = max_current * scipy.power(scipy.e, -time_elapsed / time_constant)
    return cur


def calculate_remanence(current_at_t, length_solenoid, num_coils):
    # remanent flux density (remanence)
    rem = constants.mu_0 * current_at_t / length_solenoid * num_coils
    return rem


def calculate_constant_multiplier(num_coils, current_at_t, length_solenoid, outer_diameter, inner_diameter):
    constant_multiplier = (constants.mu_0 * num_coils * current_at_t) / \
                          (2 * length_solenoid * (outer_diameter - inner_diameter))
    return constant_multiplier


def calculate_ln_term_a(outer_diameter, length_add_distance_from_center, inner_diameter):
    ln_term_a = scipy.log((outer_diameter +
                           scipy.sqrt(scipy.power(outer_diameter, 2) +
                                      scipy.power(length_add_distance_from_center, 2))) /
                          (inner_diameter +
                           scipy.sqrt(scipy.power(inner_diameter, 2) +
                                      scipy.power(length_add_distance_from_center, 2))))
    return ln_term_a


def calculate_ln_term_b(outer_diameter, length_subtract_distance_from_center, inner_diameter):
    ln_term_b = scipy.log((outer_diameter +
                           scipy.sqrt(scipy.power(outer_diameter, 2) +
                                      scipy.power(length_subtract_distance_from_center, 2))) /
                          (inner_diameter +
                           scipy.sqrt(scipy.power(inner_diameter, 2) +
                                      scipy.power(length_subtract_distance_from_center, 2))))
    return ln_term_b


def calculate_field_strength_at_p(constant_multiplier, length_add_distance_from_center, ln_term_a,
                                  length_subtract_distance_from_center, ln_term_b):
    field_strength_at_p = constant_multiplier / length_add_distance_from_center * scipy.log(ln_term_a) \
                          + constant_multiplier / length_subtract_distance_from_center * scipy.log(ln_term_b)
    return field_strength_at_p


def calculate_force_on_piston(field_strength_at_p, remanence, cross_section_area_solenoid, direction_vector):
    force_on_piston = field_strength_at_p * remanence * \
                      cross_section_area_solenoid * direction_vector / constants.mu_0
    return force_on_piston


# if __name__ == "__main__":
#   input_values()
em_force_model(input_values())
