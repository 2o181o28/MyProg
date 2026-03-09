#!/usr/bin/env python3
import numpy as np
import plotly.graph_objects as go
import math

# ====== Paste your C++ output here (already filled) ======
R = 1.741968654139
sphere_center = np.array([0.586591667027, -0.574419910062, 1.334149061836], dtype=float)

poses = [
    (np.array([0.556081095018, 0.082751163336, 1.300008870714], float),
     np.array([-7.430077514620, 7.854892072280, -7.338808422667], float)),
    (np.array([0.705010471343, -1.034255585858, 1.196762055335], float),
     np.array([5.894635364409, 9.611469170517, -16.105996323086], float)),
    (np.array([0.149887370514, -0.439472147678, 1.808577694945], float),
     np.array([13.348221949990, -12.225554385451, -2.266838560325], float)),
]

# ====== Geometry ======
def tetra_edge_from_volume(V=1.0):
    return (6.0 * math.sqrt(2.0) * V) ** (1.0/3.0)

edge = tetra_edge_from_volume(1.0)

# Same base tetra as C++: (±1,±1,±1) scaled so edge=2*sqrt(2)
base = np.array([
    [ 1.0,  1.0,  1.0],
    [ 1.0, -1.0, -1.0],
    [-1.0,  1.0, -1.0],
    [-1.0, -1.0,  1.0],
], dtype=float)
base *= edge / (2.0 * math.sqrt(2.0))

# Triangular faces (vertex indices)
faces = np.array([
    [0,1,2],
    [0,1,3],
    [0,2,3],
    [1,2,3],
], dtype=int)

# Edges for wireframe
edges = [(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]

def rot_zyx(roll, pitch, yaw):
    cr, sr = math.cos(roll), math.sin(roll)
    cp, sp = math.cos(pitch), math.sin(pitch)
    cy, sy = math.cos(yaw), math.sin(yaw)
    Rz = np.array([[cy, -sy, 0.0],
                   [sy,  cy, 0.0],
                   [0.0, 0.0, 1.0]])
    Ry = np.array([[ cp, 0.0, sp],
                   [0.0, 1.0, 0.0],
                   [-sp, 0.0, cp]])
    Rx = np.array([[1.0, 0.0, 0.0],
                   [0.0,  cr, -sr],
                   [0.0,  sr,  cr]])
    return Rz @ Ry @ Rx

def transform(base_vertices, t, eul):
    Rm = rot_zyx(float(eul[0]), float(eul[1]), float(eul[2]))
    return (base_vertices @ Rm.T) + t

tetras = [transform(base, t, eul) for (t, eul) in poses]
all_pts = np.vstack(tetras)
maxDist = np.linalg.norm(all_pts - sphere_center, axis=1).max()

print("maxDist =", maxDist, "  R =", R, "  diff =", maxDist - R)

# ====== Build Plotly Figure ======
fig = go.Figure()

tetra_colors = ["rgba(31,119,180,0.45)", "rgba(255,127,14,0.45)", "rgba(44,160,44,0.45)"]

for idx, T in enumerate(tetras):
    # Mesh triangles
    i = faces[:,0]
    j = faces[:,1]
    k = faces[:,2]
    fig.add_trace(go.Mesh3d(
        x=T[:,0], y=T[:,1], z=T[:,2],
        i=i, j=j, k=k,
        color=tetra_colors[idx],
        opacity=1.0,
        flatshading=True,
        name=f"Tetra {idx}",
        showlegend=True
    ))

    # Edge wireframe
    ex, ey, ez = [], [], []
    for a,b in edges:
        ex += [T[a,0], T[b,0], None]
        ey += [T[a,1], T[b,1], None]
        ez += [T[a,2], T[b,2], None]
    fig.add_trace(go.Scatter3d(
        x=ex, y=ey, z=ez,
        mode="lines",
        line=dict(width=4, color="black"),
        name=f"Tetra {idx} edges",
        showlegend=False
    ))

    # Vertices
    fig.add_trace(go.Scatter3d(
        x=T[:,0], y=T[:,1], z=T[:,2],
        mode="markers",
        marker=dict(size=4),
        name=f"Tetra {idx} vertices",
        showlegend=False
    ))

# Sphere surface (semi-transparent)
# (Resolution: adjust nu/nv if you want smoother)
nu, nv = 48, 24
u = np.linspace(0, 2*np.pi, nu)
v = np.linspace(0, np.pi, nv)
xs = sphere_center[0] + R * np.outer(np.cos(u), np.sin(v))
ys = sphere_center[1] + R * np.outer(np.sin(u), np.sin(v))
zs = sphere_center[2] + R * np.outer(np.ones_like(u), np.cos(v))

fig.add_trace(go.Surface(
    x=xs, y=ys, z=zs,
    opacity=0.18,
    showscale=False,
    name="Sphere",
    showlegend=False
))

# Sphere center marker
fig.add_trace(go.Scatter3d(
    x=[sphere_center[0]], y=[sphere_center[1]], z=[sphere_center[2]],
    mode="markers",
    marker=dict(size=6, symbol="x"),
    name="Sphere center"
))

# Set equal aspect ratio by using data ranges
mins = np.minimum(all_pts.min(axis=0), sphere_center - R)
maxs = np.maximum(all_pts.max(axis=0), sphere_center + R)
center = (mins + maxs) / 2.0
span = float((maxs - mins).max())
rng = np.array([center - span/2, center + span/2])

fig.update_layout(
    title=f"3 Regular Tetrahedra (Vol=1) inside Sphere<br>R={R:.12f}, maxDist={maxDist:.12f}",
    scene=dict(
        xaxis=dict(range=[rng[0,0], rng[1,0]], title="X"),
        yaxis=dict(range=[rng[0,1], rng[1,1]], title="Y"),
        zaxis=dict(range=[rng[0,2], rng[1,2]], title="Z"),
        aspectmode="cube"
    ),
    margin=dict(l=0, r=0, b=0, t=60),
    legend=dict(x=0.01, y=0.99)
)

fig.show()

