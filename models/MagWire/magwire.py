__author__ = 'wack'

# part of the magwire package

# calculate magnetic fields arising from electrical current through wires of arbitrary shape
# with the law of Biot-Savart

# written by Michael Wack 2015
# wack@geophysik.uni-muenchen.de

# tested with python 3.4.3

# some basic calculations for testing


import numpy as np

import visvis as vv

import wire
import biotsavart


# simple solenoid
w = wire.Wire(path=wire.Wire.SolenoidPath(), discretization_length=0.01, current=100).Translate((0.1, 0.1, 0)).Rotate(axis=(1, 0, 0), deg=45)
sol = biotsavart.BiotSavart(wire=w)

resolution = 0.02
volume_corner1 = (-.2, -.3, -.2)
volume_corner2 = (.3, .3, .4)

grid = np.mgrid[volume_corner1[0]:volume_corner2[0]:resolution, volume_corner1[1]:volume_corner2[1]:resolution, volume_corner1[2]:volume_corner2[2]:resolution]

# create list of grid points
points = np.vstack(map(np.ravel, grid)).T

# calculate B field at given points
B = sol.CalculateB(points=points)

Babs = np.linalg.norm(B, axis=1)

# draw results

# prepare axes
a = vv.gca()
a.cameraType = '3d'
a.daspectAuto = False

vol = Babs.reshape(grid.shape[1:]).T
vol = np.clip(vol, 0.002, 0.01)
vol = vv.Aarray(vol, sampling=(resolution, resolution, resolution), origin=(volume_corner1[2], volume_corner1[1], volume_corner1[0]))

# set labels
vv.xlabel('x axis')
vv.ylabel('y axis')
vv.zlabel('z axis')

sol.vv_PlotWires()

t = vv.volshow2(vol, renderStyle='mip', cm=vv.CM_JET)
vv.colorbar()
app = vv.use()
app.Run()
