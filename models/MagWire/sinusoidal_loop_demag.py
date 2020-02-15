__author__ = 'wack'


# part of the magwire package

# calculate magnetic fields arising from electrical current through wires of arbitrary shape
# with the law of Biot-Savart

# written by Michael Wack 2015
# wack@geophysik.uni-muenchen.de

# tested with python 3.4.3


# calculate magnetic field caused by two sinusoidal loops with opposing current directions

import numpy as np

try:
    import visvis as vv
    visvis_avail = True
except ImportError:
    visvis_avail = False
    print("visvis not found.")

from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import axes3d

import wire
import biotsavart


npts = 200
radius = .07
amp = .01
ncycle = 12.0


# define wires
w1 = wire.Wire(path=wire.Wire.SinusoidalCircularPath(radius=radius, amplitude=amp, frequency=ncycle, pts=npts), discretization_length=0.01, current=100.0)
w2 = wire.Wire(path=wire.Wire.SinusoidalCircularPath(radius=radius, amplitude=amp, frequency=ncycle, pts=npts), discretization_length=0.01, current=-100.0).Rotate(axis=(0, 0, 1), deg=360.0/ncycle/2.0)

# prepare data grid and calculate B in volume
resolution = 0.005
# volume to examine
volume_corner1 = (0, 0, 0)
volume_corner2 = (.12, .12, .05)

grid3D = np.mgrid[volume_corner1[0]:volume_corner2[0]:resolution, volume_corner1[1]:volume_corner2[1]:resolution, volume_corner1[2]:volume_corner2[2]:resolution]
grid2D = np.mgrid[volume_corner1[0]:volume_corner2[0]:resolution/2.0, volume_corner1[1]:volume_corner2[1]:resolution/2.0, 0:1]

# create list of grid points
points3D = np.vstack(map(np.ravel, grid3D)).T
points2D = np.vstack(map(np.ravel, grid2D)).T

# calculate B field at given points
bs = biotsavart.BiotSavart(wire=w1)
bs.AddWire(w2)

B = bs.CalculateB(points=points3D)
Babs = np.linalg.norm(B, axis=1)

B2D = bs.CalculateB(points=points2D)
B2Dabs = np.linalg.norm(B2D, axis=1)
B2Dabs = B2Dabs.clip(0,0.01)
B2Dabsgrid = B2Dabs.reshape(grid2D.shape[1:-1]).T


# draw results

# prepare axes
a = vv.gca()
a.cameraType = '3d'
a.daspectAuto = False

#Bgrid = B.reshape(grid3D.shape).T
Babsgrid = Babs.reshape(grid3D.shape[1:]).T

# clipping is not automatic!
Babsgrid = np.clip(Babsgrid, 0, 0.005)
Babsgrid = vv.Aarray(Babsgrid, sampling=(resolution, resolution, resolution),
                origin=(volume_corner1[2], volume_corner1[1], volume_corner1[0]))


# set labels
vv.xlabel('x axis')
vv.ylabel('y axis')
vv.zlabel('z axis')

bs.vv_PlotWires()

t = vv.volshow2(Babsgrid, renderStyle='mip', cm=vv.CM_JET)
vv.colorbar()
app = vv.use()
app.Run()


# matplotlib plot

fig = plt.figure()

# 3d quiver

#ax = fig.gca(projection='3d')
#ax.quiver(points[:, 0], points[:, 1], points[:, 2], B[:, 0], B[:, 1], B[:, 2], length=0.005)

#2d quiver
ax = fig.gca()
ax.quiver(points2D[:, 0], points2D[:, 1], B2D[:, 0], B2D[:, 1], scale=.3)
cs = ax.contour(grid2D.reshape(grid2D.shape[:-1])[0], grid2D.reshape(grid2D.shape[:-1])[1], B2Dabsgrid)
ax.clabel(cs)

plt.show()
