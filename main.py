import matplotlib.pyplot as plt
import numpy as np

# Adjust the delimiter to ', ' (comma followed by space)
x, y = np.loadtxt('particle_positions.txt', delimiter=' ', unpack=True)

plt.figure(figsize=(10, 10))
plt.scatter(x, y)
plt.title('Particle Positions')
plt.xlabel('X Position')
plt.ylabel('Y Position')
plt.xlim(0, 10)  # Adjust based on expected particle position range
plt.ylim(0, 10)  # Adjust based on expected particle position range
plt.grid(True)
plt.show()
