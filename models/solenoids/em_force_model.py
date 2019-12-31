# Purpose: Calculating the magnetic field strength at the center of the solenoid using Biot Savart Law
# This value is then used as an input to determine the electromagnetic force.
# For more information refer to 'Solenoid Research' (google docs)

# variables declarations used in this program are categorized into ...
# values to be determined by design, values to be changed during play, output/calculated values

from typing import Dict

import scipy
from scipy import constants
import matplotlib.pyplot as plt
import numpy as np

__all__ = [constants]


def input_values():
    parameter_list = {
        'length_solenoid': 10,  # length of solenoid
        'wire_gauge': 1,  # wire gauge
        'diameter': 1,  # diameter of circular, side length of square
        'side_long': 2,  # longer side for rect, longer value for ellipse
        'side_short': 1,  # shorter side for rect, shorter value for ellipse

        # External Values, changeable, but dependent on other components

        'max_voltage': 4,  # the voltage across the capacitor
        'resistance': 1,  # resistance of the device
        'capacitance': 3,  # capacitance of our capacitor

        # input values, changes to model (visually)

        'total_time': 5.,  # the time frame we wish to look at
        'time_interval': 0.2,  # ### we want to change length of pulse
    }
    return parameter_list


def time_constant(resistance, capaciatance):
    tc = resistance * capaciatance
    return tc


def max_current(max_voltage, resistance):
    mc = max_voltage / resistance
    return mc

    #    for i in range(0, parameter_list['total_time']):
    #       current_at_t.append(current(max_current, time_elapsed, time_constant))
    #      i+time_elapsed


def num_of_loops(solenoid_length, gauge_thickness):
    n = solenoid_length / gauge_thickness
    return n


# magnetic field (mf) calculations and area calculations


def calc_mf_circular_solenoid(num_loops, current, diameter):
    magnetic_field = scipy.constants.mu_0 * num_loops * current / diameter
    return magnetic_field


def cross_section_area_circle(dia):  # area calculation (cross section of solenoid)
    area = scipy.power((dia / 2), 2) * scipy.pi
    return area


def calc_mf_square_solenoid(num_loops, current, side_length):
    magnetic_field = np.sqrt(2) * scipy.constants.mu_0 * num_loops * current / (scipy.pi * side_length / 2)
    return magnetic_field


def cross_section_area_square(side_length):  # area calculation (cross section of solenoid)
    area = side_length * side_length
    return area


def calc_mf_rect_solenoid(num_loops, current, length_short, length_long):
    magnetic_field = (2 * scipy.constants.mu_0 * num_loops * current / scipy.pi) * (
            length_long / (length_short * np.sqrt(np.pow(length_long, 2) + np.pow(length_short, 2))) + length_short /
            (length_long * np.sqrt(np.pow(length_long, 2) + np.pow(length_short, 2))))
    return magnetic_field


def cross_section_area_rect(length_long, length_short):  # area calculation (cross section of solenoid)
    area = length_short * length_long
    return area


def calc_mf_oval_solenoid(num_loops, current, length_short, length_long):  # ****needs work
    magnetic_field = 1
    return magnetic_field


def calc_force(area, mf):
    force = area * scipy.pow(mf, 2) / 2 / scipy.constants.mu_0
    return force


'''# time_elapsed = np.arange(0., parameter_list['total_time'], parameter_list['time_interval'])

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

    plt.show()'''

##

# FUNCTIONS TO BE CALLED FROM MAIN FUNCTION
# THIS WAS DONE TO REDUCE CLUTTER IN THE MAIN FUNCTION AND TO CREATE LESS COMPLEX UNIT TEST CASES FOR THE FUNCTIONS

##

'''def current(max_current, time_elapsed, time_constant):
    cur = max_current * scipy.power(scipy.e, -time_elapsed / time_constant)
    return cur

'''

# if __name__ == "__main__":
#   input_values()
