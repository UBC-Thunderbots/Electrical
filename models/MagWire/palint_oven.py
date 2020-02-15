__author__ = 'wack'

# part of the magwire package

# calculate magnetic fields arising from electrical current through wires of arbitrary shape
# with the law of Biot-Savart

# written by Michael Wack 2015
# wack@geophysik.uni-muenchen.de

# tested with python 3.4.3

# calculate fields needed for an palint oven

import numpy as np
import matplotlib.pyplot as plt
from copy import deepcopy
import wire
import biotsavart

# two solenoids

w1 = wire.Wire(path=wire.Wire.SolenoidPath(radius=0.1, pitch=0.02, turns=20), discretization_length=0.01, current=10).Rotate(axis=(0, 1, 0), deg=90)
w2 = wire.Wire(path=wire.Wire.SolenoidPath(radius=0.1, pitch=0.02, turns=30), discretization_length=0.01, current=20).Rotate(axis=(0, 1, 0), deg=90).Translate([.45,0,0])

sol = biotsavart.BiotSavart(wire=w1)
sol.AddWire(w2)

resolution = 0.01
xy_corner1 = (-.2, -.09)
xy_corner2 = (.8+1e-10, .09)

# matplotlib plot 2D
# create list of xy coordinates
grid = np.mgrid[xy_corner1[0]:xy_corner2[0]:resolution, xy_corner1[1]:xy_corner2[1]:resolution]

# create list of grid points
points = np.vstack(map(np.ravel, grid)).T
points = np.hstack([points, np.zeros([len(points),1])])

# calculate B field at given points
B = sol.CalculateB(points=points)
Babs = np.linalg.norm(B, axis=1)

# remove big values close to the wire
#cutoff = 0.005

#B[Babs > cutoff] = [np.nan,np.nan,np.nan]
#Babs[Babs > cutoff] = np.nan



#2d quiver
# get 2D values from one plane with Z = 0

fig = plt.figure()
ax = fig.gca()
ax.quiver(points[:, 0], points[:, 1], B[:, 0], B[:, 1], scale=.15)
X = np.unique(points[:, 0])
Y = np.unique(points[:, 1])
cs = ax.contour(X, Y, Babs.reshape([len(X), len(Y)]).T, 10)
ax.clabel(cs)
plt.xlabel('x')
plt.ylabel('y')
plt.axis('equal')
plt.show()


x_vals = np.arange(xy_corner1[0],xy_corner2[0],resolution)
points = np.array( [x_vals, x_vals*0, x_vals*0]).T
print(points)
B = sol.CalculateB(points=points)
Babs = np.linalg.norm(B, axis=1)

fig = plt.figure()
plt.plot(points[:,0], Babs)
plt.xlabel('x[m]')
plt.ylabel('B[T]')
plt.show()

