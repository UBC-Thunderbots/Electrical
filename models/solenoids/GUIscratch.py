from tkinter import *
from tkinter import ttk
from models.solenoids.em_force_model import *
class solenoidGUI:

    def __init__(self, master):
        self.master = master
        master.title("window title")
        # geometry: width x height
        master.geometry('1080x720')
        self.description_label = Label(master, text="Solenoid Model", font=("Arial Bold", 40)).grid(
            column=0, row=0)

        # Changeable Parameters
        self.description_label = Label(master, text="Changeable parameters: geometry", font=("Arial Bold", 20)).grid(column=0,
                                                                                                                     row=1)
        frame = Frame(master)
        frame.grid(column=0, row=2)

        self.description_length_solenoid = Label(frame, text="Solenoid Length in mm").grid(column=0, row=1)
        self.length_solenoid = Entry(frame, width=10)
        self.length_solenoid.grid(column=1, row=1)

        self.description_gauge_thickness = Label(frame, text="Gauge Thickness in mm").grid(column=0, row=2)
        self.gauge_thickness = Entry(frame, width=10)
        self.gauge_thickness.grid(column=1, row=2)

        # if circle, square, show
        self.description_diameter = Label(frame, text="Diameter (square, circular)").grid(column=0, row=3)
        self.diameter = Entry(frame, width=10)
        self.diameter.grid(column=1, row=3)

        # if rectangle, oval, show
        self.description_side_long = Label(frame, text="Length of longer side").grid(column=0, row=4)
        self.side_long = Entry(frame, width=10)
        self.side_long.grid(column=1, row=4)

        self.description_side_short = Label(frame, text="Length of shorter side").grid(column=0, row=5)
        self.side_short = Entry(frame, width=10)
        self.side_short.grid(column=1, row=5)

        # External Values, changeable, but dependent on other components
        self.description_label2 = Label(master, text="Parameters: external circuit", font=("Arial Bold", 20)).grid(
            column=0, row=3)
        frame2 = Frame(master)
        frame2.grid(column=0, row=4)

        self.description_voltage = Label(frame2, text="Voltage in V").grid(column=0, row=1)
        self.voltage = Entry(frame2, width=10)
        self.voltage.grid(column=1, row=1)

        self.description_resistance = Label(frame2, text="resistance in ohms").grid(column=0, row=2)
        self.resistance = Entry(frame2, width=10)
        self.resistance.grid(column=1, row=2)

        self.input_shape = ttk.Combobox(frame, values=["rectangle", "circle", "ellipse", "square"])
        self.input_shape.current(0)  # set the selected item
        self.input_shape.grid(column=0, row=0)

        # click to solve
        self.button = Button(master, text='Solve', command=self.calc)
        self.button.grid(column=0, row=9)
        self.close_button = Button(master, text="Close", command=master.quit).grid(column=0, row=10)
        # output
        self.output_label = Label(master, text="output here")
        self.output_label.grid(column=0, row=11)

    def calc(self):
        n = num_of_loops(float(self.length_solenoid.get()), float(self.gauge_thickness.get()))

        i = max_current(float(self.voltage.get()), float(self.resistance.get()))

        # get shape
        # ​
        # if circle
        area = cross_section_area_circle(float(self.diameter.get()))
        mf = calc_mf_circular_solenoid(n, i, float(self.diameter.get()))

        # if square

        # printed = calc_force(area, mf)
        printed = (float(self.diameter.get()))

        self.output_label.configure(text=printed)


if __name__ == '__main__':
    root = Tk()
    my_gui = solenoidGUI(root)
    root.mainloop()
    # AWG conversions to mm
    import json

    with open('awg_data.json', 'r') as awg_json:
        awg_data = json.load(awg_json)
        print(awg_data['AWG'])
