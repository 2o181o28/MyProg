#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt

# 网格
n = 1000
x = np.linspace(-2, -1, n)
y = np.linspace(3, 5, n)
X, Y = np.meshgrid(x, y)

# 函数
F = np.exp(-(Y+X**3)**2)-(Y**2/32+np.exp(np.sin(Y)))

# 正值区域 mask
pos = F > 0

plt.figure()
plt.imshow(
    pos.astype(int),
    extent=[x.min(), x.max(), y.min(), y.max()],
    origin="lower",
    aspect="equal"
)
plt.title("Region where f(x,y) > g(x,y)")
plt.xlabel("x"); plt.ylabel("y")
plt.show()
