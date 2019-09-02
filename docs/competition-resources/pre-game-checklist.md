# Pre-game checklist



This checklist should be followed after any electrical or mechanical work is done on a robot to ensure it is ready for use, after the mechanical team certifies the robot.

First, with no battery installed:

* Ensure all wheels and the dribbler spin smoothly and freely and do not bind; report any issues to the mechanical team.
* Ensure all wheels does not slip when the robot is level on the ground. \(Test each wheel individually\)
* Ensure all three circuit boards are securely screwed down, the breakout board with four screws, the main board with three, and the chicker board with two.
* Ensure the wheel motor cables and optical encoder cables are attached to the breakout board, the dribbler motor is attached to the main board, and the solenoids are attached to the chicker board.
* Ensure the dribbler connector to the main board is not loose.
* Ensure the X-marked hole on the chicker board does not have a screw in it, as such a screw would be too close to components.
* Ensure there is intact Kapton tape on the tabs of the IGBTs on the chicker board. The IGBT tabs have the same voltage as the capacitor banks. It is danger without the insulating Kapton tape.
* Ensure the ground wire is securely attached to the appropriate hole on the chassis. This ground wire provide a safe return path for current in case the solenoid terminals touch robot chassis.
* Use a metre and ensure that the resistance between the robot chassis and the battery connector negative wire is no more than 1 ohm.
* Use a metre and ensure that the resistance between the robot chassis and each of the four pins in the solenoid connectors settles, after some time, at a steady state resistance of at least 100 ohms.

Then, put the robot on a stand \(roll of tape\), attach a battery, set the appropriate communication settings on the switches, power up the robot, establish communication with the MRF tester, and:

* Check that there are no unexpected messages in the annunciator panel.
* Switch to per-motor mode and apply a drive level of 25 to all four wheels. Ensure the wheels are turning. For each wheel in turn, grab the wheel and let it turn slowly. It should turn smoothly and with constant torque; serious variation in torque indicates that a phase wire to the motor has failed. Check whether there is a flickering yellow LED on the main board; if so, this indicates that the break beam is false triggering due to motor noise. Then turn the motors off \(zero PWM\).
* Turn the dribbler on and run it up to 4500 RPM. It should reach and maintain that speed. Check whether there is a flickering yellow LED on the main board; if so, this indicates that the break beam is false triggering due to motor noise. Then turn the dribbler off again.
* Ensure the capacitors are discharged and the autokick button is not pressed. Ensure the break beam value is at least 0.05 and the yellow light is off. Block the beam with a finger and ensure the reading goes to near zero and the light comes on.
* Charge the capacitors. Ensure it charges to 240 volts in a couple of seconds and holds there and that the red light is on. Set kick power to 8 m/s and fire the kicker; ensure the solenoid fires without any sparking and that the capacitors recharge. Set chip distance to 1 m, fire the chipper, and check the same.
* Float the capacitors and make sure that the capacitor voltage doesn't drop for much more than 1V per couple of seconds.
* Discharge the capacitors.
* Shut down the robot.
* Reset the robot’s radio to configuration zero on the switches. Tips:
* The `z` key resets all motor drive levels/setpoints to zero and turns off the dribbler.
* PageUp/PageDown move the selected slider by a larger step

