
from unittest import TestCase
from .em_force_model import em_force_model, calculate_remanence


class EmForceModelTestCase(TestCase):
    def __init__(self, *args):
        super(EmForceModelTestCase, self).__init__(*args)
    
    def setUp(self):
        pass
    
    def tearDown(self):
        pass

    def calculate_remanence_test_case(self):
        current = 0.1 # Amps
        length_solenoid = 10 #
        num_turns = 50 #
        val = calculate_remanence(
            current,
            length_solenoid,
            num_turns
        )
        self.assert(val == 1, "Expected not equal")




