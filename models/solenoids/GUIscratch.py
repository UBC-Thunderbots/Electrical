from tkinter import *
from em_force_model import *




class solenoidGUI:

    def __init__(self, master):
        self.master = master
        master.title("window title")
        # geometry: width x height
        master.geometry('1080x720')
        self.descriptionlabel = Label(master, text="Solenoid Model", font=("Arial Bold", 40)).grid(
            column=0, row=0)

        # Changable Parameters
        self.descriptionlabel = Label(master, text="Changable parameters: geometry", font=("Arial Bold", 20)).grid(column=0, row=1)
        frame = Frame(master)
        frame.grid(column=0, row=2)

        self.description_length_solenoid = Label(frame, text="Solenoid Length in mm").grid(column=0, row=1)
        self.length_solenoid = Entry(frame, width = 10)
        self.length_solenoid.grid (column = 1, row =1)

        self.description_gauge_thickness = Label(frame, text="Guage Thickness in mm").grid(column=0, row=2)
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
        self.descriptionlabel2 = Label(master, text="Parameters: external circut", font=("Arial Bold", 20)).grid(
            column=0, row=3)
        frame2 = Frame(master)
        frame2.grid(column=0, row=4)

        self.description_voltage= Label(frame2, text="Voltage in V").grid(column=0, row=1)
        self.voltage = Entry(frame2, width=10)
        self.voltage.grid(column=1, row=1)

        self.description_resistance = Label(frame2, text="resistance in ohms").grid(column=0, row=2)
        self.resistance = Entry(frame2, width=10)
        self.resistance.grid(column=1, row=2)





        # self.inputshape = Combobox(frame)
        # self.inputshape['Shape of Solenoid'] = ("rectangle", "circle", "ellipse")
        # combo.current("circle")  # set the selected item
        # combo.grid(column=0, row=0)








        # click to solve
        self.button = Button(master, text='Solve', command=self.calc)
        self.button.grid (column = 0, row =9)
        self.close_button = Button(master, text="Close", command=master.quit).grid(column = 0, row = 10)
        # output
        self.outputlabel = Label(master, text="output here")
        self.outputlabel.grid(column=0, row=11)

    def calc(self):
        n = num_of_loops(float(self.length_solenoid.get()), float(self.gauge_thickness.get()))

        i = max_current(float(self.voltage.get()), float(self.resistance.get()))

        # if circle
        area = cross_section_area_circle(float(self.diameter.get()))
        mf = calc_mf_circular_solenoid(n, i, float(self.diameter.get()))

        # if square

        # printed = calc_force(area, mf)
        printed = (float(self.diameter.get()))

        self.outputlabel.configure(text = printed)

root = Tk()
my_gui = solenoidGUI(root)
root.mainloop()