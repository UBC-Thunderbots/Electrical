__author__ = 'wack'

# part of the magwire package

# calculate magnetic fields arising from electrical current through wires of arbitrary shape
# with the law of Biot-Savart

# written by Michael Wack 2015
# wack@geophysik.uni-muenchen.de

# tested with python 3.4.3

# some basic calculations for testing

import numpy as np
import matplotlib.pyplot as plt
import wire
import biotsavart


# simple solenoid
# approximated analytical solution: B = mu0 * I * n / l = 4*pi*1e-7[T*m/A] * 100[A] * 10 / 0.5[m] = 2.5mT


w = wire.Wire(path=wire.Wire.SolenoidPath(pitch=0.05, turns=10), discretization_length=0.01, current=100).Rotate(axis=(1, 0, 0), deg=90) #.Translate((0.1, 0.1, 0)).
sol = biotsavart.BiotSavart(wire=w)

resolution = 0.04
volume_corner1 = (-.2, -.8, -.2)
volume_corner2 = (.2+1e-10, .3, .2)

# matplotlib plot 2D
# create list of xy coordinates
grid = np.mgrid[volume_corner1[0]:volume_corner2[0]:resolution, volume_corner1[1]:volume_corner2[1]:resolution]

# create list of grid points
points = np.vstack(map(np.ravel, grid)).T
points = np.hstack([points, np.zeros([len(points),1])])

# calculate B field at given points
B = sol.CalculateB(points=points)


Babs = np.linalg.norm(B, axis=1)

# remove big values close to the wire
cutoff = 0.005

B[Babs > cutoff] = [np.nan,np.nan,np.nan]
#Babs[Babs > cutoff] = np.nan

for ba in B:
    print(ba)

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


# matplotlib plot 3D

grid = np.mgrid[volume_corner1[0]:volume_corner2[0]:resolution*2, volume_corner1[1]:volume_corner2[1]:resolution*2, volume_corner1[2]:volume_corner2[2]:resolution*2]

# create list of grid points
points = np.vstack(map(np.ravel, grid)).T

# calculate B field at given points
B = sol.CalculateB(points=points)

Babs = np.linalg.norm(B, axis=1)

fig = plt.figure()
# 3d quiver
ax = fig.gca(projection='3d')
sol.mpl3d_PlotWires(ax)
ax.quiver(points[:, 0], points[:, 1], points[:, 2], B[:, 0], B[:, 1], B[:, 2], length=0.04)
plt.show()



