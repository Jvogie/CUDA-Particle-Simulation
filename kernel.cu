#include <fstream>
#include <iostream>
#include <cuda_runtime.h>

struct Particle {
    float x, y; // Position
    float vx, vy; // Velocity
};

__global__ void update_particles(Particle* particles, int n, float deltaTime) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        particles[idx].x += particles[idx].vx * deltaTime;
        particles[idx].y += particles[idx].vy * deltaTime;
    }
}

void init_particles(Particle* particles, int n) {
    for (int i = 0; i < n; ++i) {
        particles[i].x = rand() % 1000 / 100.0f;
        particles[i].y = rand() % 1000 / 100.0f;
        particles[i].vx = rand() % 200 / 100.0f - 1.0f; // Velocity between -1.0 and 1.0
        particles[i].vy = rand() % 200 / 100.0f - 1.0f; // Velocity between -1.0 and 1.0
    }
}

int main() {
    int n = 1024; // Number of particles
    float deltaTime = 0.1f; // Time step

    Particle* particles = new Particle[n];
    Particle* d_particles;
    size_t size = n * sizeof(Particle);

    init_particles(particles, n);

    cudaMalloc(&d_particles, size);
    cudaMemcpy(d_particles, particles, size, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(256);
    dim3 blocksPerGrid((n + threadsPerBlock.x - 1) / threadsPerBlock.x);

    update_particles << <blocksPerGrid, threadsPerBlock >> > (d_particles, n, deltaTime);

    cudaMemcpy(particles, d_particles, size, cudaMemcpyDeviceToHost);

    std::ofstream outFile("particle_positions.txt");
    for (int i = 0; i < n; i++) {
        outFile << particles[i].x << " " << particles[i].y << std::endl;
    }
    outFile.close();

    cudaFree(d_particles);
    delete[] particles;
    return 0;
}
